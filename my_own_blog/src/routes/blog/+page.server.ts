import { STRAVA_CLIENT_ID, STRAVA_CLIENT_SECRET, STRAVA_REFRESH_TOKEN, STRAVA_ATHLETE_ID } from '$env/static/private';
import type { PageServerLoad } from './$types';

interface StravaStats {
  all_run_totals: {
    count: number;
    distance: number;
  };
  all_ride_totals: {
    count: number;
    distance: number;
  };
}

async function refreshAccessToken() {
  const response = await fetch('https://www.strava.com/oauth/token', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      client_id: STRAVA_CLIENT_ID,
      client_secret: STRAVA_CLIENT_SECRET,
      refresh_token: STRAVA_REFRESH_TOKEN,
      grant_type: 'refresh_token'
    })
  });

  const tokens = await response.json();

  if (!response.ok) {
    console.error('Token refresh failed:', tokens);
    throw new Error(`Token refresh failed: ${JSON.stringify(tokens)}`);
  }

  return tokens.access_token;
}

async function getAthleteStats(accessToken: string): Promise<StravaStats> {
  const response = await fetch(
    `https://www.strava.com/api/v3/athletes/${STRAVA_ATHLETE_ID}/stats`,
    {
      headers: {
        'Authorization': `Bearer ${accessToken}`
      }
    }
  );

  if (!response.ok) {
    const errorText = await response.text();
    console.error('Strava API Error:', response.status, errorText);
    throw new Error(`Failed to fetch stats: ${response.status} - ${errorText}`);
  }

  return await response.json();
}

export const load: PageServerLoad = async () => {
  try {
    const accessToken = await refreshAccessToken();
    const stats = await getAthleteStats(accessToken);
    
    return {
      stats
    };
  } catch (error) {
    console.error('Error fetching Strava stats:', error);
    return {
      stats: null,
      error: 'Failed to load Strava stats'
    };
  }
};
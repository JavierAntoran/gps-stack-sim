```
     Almanac and Ephemeris Data as used by GPS receivers
                     (4 July 1998)

The  satellites  broadcast  two  types  of  data,   Almanac   and 
Ephemeris.   Almanac  data is course orbital parameters  for  all 
SVs.  Each SV broadcasts Almanac data for ALL SVs.  This  Almanac 
data  is  not  very precise and is considered  valid  for  up  to 
several  months.   Ephemeris data by comparison is  very  precise 
orbital  and  clock correction for each SV and is  necessary  for 
precise  positioning.  EACH SV broadcasts ONLY its own  Ephemeris 
data.   This data is only considered valid for about 30  minutes.
The Ephemeris data is broadcast by each SV every 30 seconds.

When the GPS is initially turned on after being off for more than 
30 minutes,  it "looks" for SVs based on where it is based on the 
almanac  and current time.  With this  information,   appropriate 
SVs can be selected for initial search.

When  the  GPS receiver initially locks onto a  SV,   the  Garmin 
display then shows "hollow" signal strength bars.  At this  time,
the Ephemeris data has yet to be completely collected.  Once  the 
ephemeris data is collected from EACH SV in turn,  the associated 
signal  strength  bar will turn "solid" black and then  the  data 
from that SV is considered valid for navigation.

If power is cycled on a GPS unit,  and when turned back on,   the 
Ephemeris data is less than 30 minutes old,  lock-on will be very 
quick since the GPS does not have to collect new Ephemeris  data.
This is called a "warm" start.

If  it  is later than 30 minutes,  this is  considered  a  "cold" 
start and all Ephemeris data will have to be recollected.

If  the GPS has moved more than a few hundred miles  or  accurate 
time  is lost,  the Almanac data will be invalid and if  you  are 
far  enough off,  none of the SVs that the Almanac thinks  should 
be  overhead will be there.  In such case,  the GPS will have  to 
"sky search" or be reinitialized so it can download a new Almanac 
and start over.

(Note:   Yes!  We know this is somewhat  simplified  information.
Yes,  we know that the Ephemeris data may not have to be  updated 
as  often  as  the  G-12XL does it to  get  data  to  the  G-12XL 
accuracy.)
================================================================

Joe Mehaffey
```

# Almanacs

Download YUMA Almanacs from: 
- http://celestrak.com/GPS/almanac/Yuma/ 
- https://www.navcen.uscg.gov/?pageName=gpsAlmanacs

# Ephemeris

Download from:
- https://cddis.nasa.gov/Data_and_Derived_Products/GNSS/broadcast_ephemeris_data.html

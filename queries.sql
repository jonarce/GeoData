/* Le Tour Eiffel
   latitude: 48.858370
   longitude: 2.294481
   using Natural Earth data
*/
SELECT name FROM countries WHERE 
	ST_within(GeomFromText('POINT(2.294481 48.858370)'),countries.Geometry);

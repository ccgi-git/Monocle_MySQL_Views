use ccgitranscripts;
CREATE OR REPLACE VIEW grades_wip_counts AS

WITH recent_files as (    
select
	substr(t1.filename, 1, 9),
	t1.filename, t1.inserted_at,
	ROW_NUMBER() OVER (	
		PARTITION BY substr(t1.filename, 1, 9)
        ORDER BY inserted_at DESC
	) row_num
from 
	(
		SELECT 
		distinct filename, inserted_at
		FROM ccgitranscripts.archive_course_grades
	) t1

ORDER BY filename, inserted_at ASC
)


, course_grade_files as (

SELECT 
	# substr(CDS_CODE, 1, 7) as district_cds_code,
    CDS_CODE,
	filename,
    inserted_at,
    school_year,
    term,
    CASE WHEN work_in_progress = 'N' THEN 1 ELSE 0 END AS GRADES,
    CASE WHEN work_in_progress = 'Y' THEN 1 ELSE 0 END AS WIP
FROM ccgitranscripts.archive_course_grades
WHERE filename IN (select filename from recent_files WHERE row_num = 1 )

### UPDATE ACADEMIC YEAR BELOW ####

AND school_year = '2020-21'

) 

, agg_course_grade_files as (

	select 
		filename,
		inserted_at,
		school_year,
		term,
		sum(grades) as total_grades,
		sum(wip) as total_wip
	from course_grade_files
	group by 
		filename,
		inserted_at,
		school_year,
		term
)

-- , filename_to_districtname as (
-- 	select
-- 		cgs1.filename, 
-- 		cgs1.cds_code as top_cds_code,
-- 		concat(substr(cgs1.cds_code,1,7), '0000000' ) as district_cds_code,
-- 		district_lookup.District
-- 	from (
-- 		select
-- 		cg.filename, 
-- 		cg.cds_code,
-- 		ROW_NUMBER() OVER (	
-- 			PARTITION BY cg.filename
-- 			ORDER BY cg.total_courses DESC
-- 		) row_num
-- 		from (
-- 			select 
-- 				CDS_CODE, filename, sum(grades)+sum(wip) as total_courses 
-- 			from course_grade_files
-- 			group by CDS_CODE, filename
-- 			order by filename, sum(grades)+sum(wip) desc
-- 		) cg
-- 	) cgs1 
-- 	left join (
-- 		SELECT 
-- 			DISTINCT
-- 			CDSCode,
-- 			District
-- 		FROM ccgitranscripts.cds_codes
-- 		WHERE SOCType = 'No Data'
-- 		order by CDSCode
-- 	) district_lookup 
-- 	on concat(substr(cgs1.cds_code,1,7), '0000000' ) = district_lookup.CDSCode
-- 	where cgs1.row_num = 1
-- ) select distinct substr(filename, 1, 9) sname, district from filename_to_districtname order by 2;

select 
    case 
		when substr(filename, 1, 9) =	'PUHSD_CCG'	then	'Perris Union High '
		when substr(filename, 1, 9) =	'applevall'	then	'Apple Valley Unified'
		when substr(filename, 1, 9) =	'brawleyad'	then	'Brawley Union High'
		when substr(filename, 1, 9) =	'centinela'	then	'Centinela Valley Union High'
		when substr(filename, 1, 9) =	'centralad'	then	'Central Unified'
		when substr(filename, 1, 9) =	'ceresadmi'	then	'Ceres Unified'
		when substr(filename, 1, 9) =	'chaffeyad'	then	'Chaffey Joint Union High'
		when substr(filename, 1, 9) =	'chinoadmi'	then	'Chino Valley Unified'
		when substr(filename, 1, 9) =	'coachella'	then	'Coachella Valley Unified'
		when substr(filename, 1, 9) =	'comptonad'	then	'Compton Unified'
		when substr(filename, 1, 9) =	'cutleroro'	then	'Cutler-Orosi Joint Unified'
		when substr(filename, 1, 9) =	'delhiadmi'	then	'Delhi Unified'
		when substr(filename, 1, 9) =	'denairadm'	then	'Denair Unified'
		when substr(filename, 1, 9) =	'desertadm'	then	'Desert Sands Unified'
		when substr(filename, 1, 9) =	'dinubaadm'	then	'Dinuba Unified'
		when substr(filename, 1, 9) =	'elranchoa'	then	'El Rancho Unified'
		when substr(filename, 1, 9) =	'elkgrovea'	then	'Elk Grove Unified'
		when substr(filename, 1, 9) =	'escalonad'	then	'Escalon Unified'
		when substr(filename, 1, 9) =	'exeteradm'	then	'Exeter Unified'
		when substr(filename, 1, 9) =	'farmersvi'	then	'Farmersville Unified'
		when substr(filename, 1, 9) =	'firebaugh'	then	'Firebaugh-Las Deltas Unified'
		when substr(filename, 1, 9) =	'FresnoUni'	then	'Fresno Unified'
		when substr(filename, 1, 9) =	'gardenadm'	then	'Garden Grove Unified'
		when substr(filename, 1, 9) =	'gilroyadm'	then	'Gilroy Unified'
		when substr(filename, 1, 9) =	'goldenpla'	then	'Golden Plains Unified'
		when substr(filename, 1, 9) =	'hanfordad'	then	'Hanford Joint Union High'
		when substr(filename, 1, 9) =	'haywardad'	then	'Hayward Unified'
		when substr(filename, 1, 9) =	'hemetadmi'	then	'Hemet Unified'
		when substr(filename, 1, 9) =	'hesperiaa'	then	'Hesperia Unified'
		when substr(filename, 1, 9) =	'hughsonad'	then	'Hughson Unified'
		when substr(filename, 1, 9) =	'jefferson'	then	'Jefferson Union High'
		when substr(filename, 1, 9) =	'jurupaadm'	then	'Jurupa Unified'
		when substr(filename, 1, 9) =	'kermanadm'	then	'Kerman Unified'
		when substr(filename, 1, 9) =	'kingscany'	then	'Kings Canyon Joint Unified'
		when substr(filename, 1, 9) =	'lakeelsin'	then	'Lake Elsinore Unified'
		when substr(filename, 1, 9) =	'legrandad'	then	'Le Grand Union High'
		when substr(filename, 1, 9) =	'lemooread'	then	'Lemoore Union High'
		when substr(filename, 1, 9) =	'lindsayad'	then	'Lindsay Unified'
		when substr(filename, 1, 9) =	'greendota'	then	'Los Angeles Unified'
		when substr(filename, 1, 9) =	'losbanosa'	then	'Los Banos Unified'
		when substr(filename, 1, 9) =	'maderaadm'	then	'Madera Unified'
		when substr(filename, 1, 9) =	'maricopaa'	then	'Maricopa Unified'
		when substr(filename, 1, 9) =	'mcfarland'	then	'McFarland Unified'
		when substr(filename, 1, 9) =	'mendotaad'	then	'Mendota Unified'
		when substr(filename, 1, 9) =	'morenoadm'	then	'Moreno Valley Unified'
		when substr(filename, 1, 9) =	'MVUSD_CCG'	then	'Murrieta Valley Unified'
		when substr(filename, 1, 9) =	'newmancro'	then	'Newman-Crows Landing Unified'
		when substr(filename, 1, 9) =	'norwalkla'	then	'Norwalk-La Mirada Unified'
		when substr(filename, 1, 9) =	'oceanside'	then	'Oceanside Unified'
		when substr(filename, 1, 9) =	'palmsprin'	then	'Palm Springs Unified'
		when substr(filename, 1, 9) =	'pasadenaa'	then	'Pasadena Unified'
		when substr(filename, 1, 9) =	'placeradm'	then	'Placer Union High'
		when substr(filename, 1, 9) =	'Pomona_CC'	then	'Pomona Unified'
		when substr(filename, 1, 9) =	'portervil'	then	'Porterville Unified'
		when substr(filename, 1, 9) =	'redlandsa'	then	'Redlands Unified'
		when substr(filename, 1, 9) =	'riverdale'	then	'Riverdale Joint Unified'
		when substr(filename, 1, 9) =	'riverside'	then	'Riverside County Office of Education'
		when substr(filename, 1, 9) =	'sacrament'	then	'Sacramento City Unified'
		when substr(filename, 1, 9) =	'sanluisco'	then	'San Luis Coastal Unified'
		when substr(filename, 1, 9) =	'SMUSD_CCG'	then	'San Marcos Unified'
		when substr(filename, 1, 9) =	'sangeradm'	then	'Sanger Unified'
		when substr(filename, 1, 9) =	'SAUSD_CCG'	then	'Santa Ana Unified'
		when substr(filename, 1, 9) =	'selmaadmi'	then	'Selma Unified'
		when substr(filename, 1, 9) =	'shandonad'	then	'Shandon Joint Unified'
		when substr(filename, 1, 9) =	'sierrasan'	then	'Sierra Sands Unified'
		when substr(filename, 1, 9) =	'snowlinej'	then	'Snowline Joint Unified'
		when substr(filename, 1, 9) =	'taftunion'	then	'Taft Union High'
		when substr(filename, 1, 9) =	'TVUSD_CCG'	then	'Temecula Valley Unified'
		when substr(filename, 1, 9) =	'tracyjoin'	then	'Tracy Joint Unified'
		when substr(filename, 1, 9) =	'tularejoi'	then	'Tulare Joint Union High'
		when substr(filename, 1, 9) =	'valverdea'	then	'Val Verde Unified'
		when substr(filename, 1, 9) =	'visaliaad'	then	'Visalia Unified'
		when substr(filename, 1, 9) =	'VUSD_CCGI'	then	'Vista Unified'
		when substr(filename, 1, 9) =	'wascoadmi'	then	'Wasco Union High'
		when substr(filename, 1, 9) =	'washingto'	then	'Washington Unified'
		when substr(filename, 1, 9) =	'waterford'	then	'Waterford Unified'
		when substr(filename, 1, 9) =	'woodlakea'	then	'Woodlake Unified'
		when substr(filename, 1, 9) =	'woodlanda'	then	'Woodland Joint Unified'
		else 'DISTRICT NAME NOT IDENTIFIED'
    end as district,
	filename,
	inserted_at,
	school_year,
	term,
	total_grades,
	total_wip

from 
	agg_course_grade_files
order by 1,5

;
#####################################################

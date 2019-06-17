#! /bin/bash

printf "\n"
echo "---------------------------------------------"
printf "DATA Crcdata START\n\n"

cd $i2b2_DATA
cd Crcdata
ant -f data_build.xml create_crcdata_tables_release_1-7
ant -f data_build.xml create_procedures_release_1-7
ant -f data_build.xml db_demodata_load_data


printf "\n"
echo "---------------------------------------------"
printf "DATA Crcdata END\n\n"


printf "\n"
echo "---------------------------------------------"
printf "DATA Hivedata START\n\n"

cd $i2b2_DATA
cd Hivedata
ant -f data_build.xml create_hivedata_tables_release_1-7
ant -f data_build.xml db_hivedata_load_data

printf "\n"
echo "---------------------------------------------"
printf "DATA Hivedata END\n\n"


printf "\n"
echo "---------------------------------------------"
printf "DATA Imdata START\n\n"

cd $i2b2_DATA
cd Imdata
ant -f data_build.xml create_imdata_tables_release_1-7
ant -f data_build.xml db_imdata_load_data

printf "\n"
echo "---------------------------------------------"
printf "DATA Imdata END\n\n"


printf "\n"
echo "---------------------------------------------"
printf "DATA Metadata START\n\n"

cd $i2b2_DATA
cd Metadata
ant -f data_build.xml create_metadata_tables_release_1-7
ant -f data_build.xml db_metadata_load_data

printf "\n"
echo "---------------------------------------------"
printf "DATA Metadata END\n\n"


printf "\n"
echo "---------------------------------------------"
printf "DATA Pmdata START\n\n"

cd $i2b2_DATA
cd Pmdata
ant -f data_build.xml create_pmdata_tables_release_1-7
ant -f data_build.xml create_triggers_release_1-7
ant -f data_build.xml db_pmdata_load_data


printf "\n"
echo "---------------------------------------------"
printf "DATA Pmdata END\n\n"


printf "\n"
echo "---------------------------------------------"
printf "DATA Workdata START\n\n"

cd $i2b2_DATA
cd Workdata
ant -f data_build.xml create_workdata_tables_release_1-7
ant -f data_build.xml db_workdata_load_data

printf "\n"
echo "---------------------------------------------"
printf "DATA Workdata END\n\n"

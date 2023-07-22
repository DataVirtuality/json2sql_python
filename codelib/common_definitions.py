
from dataclasses import dataclass
from typing import Dict, Final, Set


SAMPLE_DATA_JSON: Final[str] = 'sample_data_json'
SAMPLE_DATA_XML: Final[str] = 'sample_data_xml'
TEST_CASES_JSON: Final[str] = 'test_cases_json'
TEST_CASES_XML: Final[str] = 'test_cases_xml'

DV_PATH_SAMPLE_DATA_JSON: Final[str] = '/opt/datavirtuality/sample-data-json'
DV_PATH_SAMPLE_DATA_XML: Final[str] = '/opt/datavirtuality/sample-data-xml'
DV_PATH_TEST_CASES_JSON: Final[str] = '/opt/datavirtuality/test-cases-json'
DV_PATH_TEST_CASES_XML: Final[str] = '/opt/datavirtuality/test-cases-xml'

DV_CONNECTION_NAMES: Final[Set[str]] = {SAMPLE_DATA_JSON, SAMPLE_DATA_XML, TEST_CASES_JSON, TEST_CASES_XML}

DV_CONNECTION_PATHS: Final[Dict[str, str]] = {
    SAMPLE_DATA_JSON: DV_PATH_SAMPLE_DATA_JSON,
    SAMPLE_DATA_XML: DV_PATH_SAMPLE_DATA_XML,
    TEST_CASES_JSON: DV_PATH_TEST_CASES_JSON,
    TEST_CASES_XML: DV_PATH_TEST_CASES_XML
}

LOCAL_PATH_SAMPLE_DATA_JSON: Final[str] = 'sample-data-json'
LOCAL_PATH_SAMPLE_DATA_XML: Final[str] = 'sample-data-xml'
LOCAL_PATH_TEST_CASES_JSON: Final[str] = 'test-cases-json'
LOCAL_PATH_TEST_CASES_XML: Final[str] = 'test-cases-xml'


LOCAL_CONNECTION_PATHS: Final[Dict[str, str]] = {
    SAMPLE_DATA_JSON: LOCAL_PATH_SAMPLE_DATA_JSON,
    SAMPLE_DATA_XML: LOCAL_PATH_SAMPLE_DATA_XML,
    TEST_CASES_JSON: LOCAL_PATH_TEST_CASES_JSON,
    TEST_CASES_XML: LOCAL_PATH_TEST_CASES_XML
}


@dataclass
class DV_ConnectionInfo:
    dv_ip_addr: Final[str] = '192.168.6.130'
    dv_port: Final[int] = 31000
    jdbc_class_name: Final[str] = "com.datavirtuality.dv.jdbc.Driver"
    dv_database: Final[str] = "datavirtuality"
    dv_use_ssl: Final[bool] = False
    dv_uid: Final[str] = "admin"
    dv_pwd: Final[str] = "admin"
    driver_file: Final[str] = "datavirtuality-jdbc_2.1.16-1.jar"

    def jdbc_use_ssl_str(self) -> str:
        return "mms" if self.dv_use_ssl else "mm"

    def connection_string(self) -> str:
        return f"jdbc:datavirtuality:{self.dv_database}@{self.jdbc_use_ssl_str()}://{self.dv_ip_addr}:{self.dv_port};"

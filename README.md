# terraform
## backend/backend.tf
### 1. Terraform State Storage 설정
1) Terraform의 state 파일을 저장할 S3 버킷과 이를 관리하는 DynamoDB 테이블을 설정하였습니다.
    1) <b>S3 버킷 생성 [aws_s3_bucket]</b>
    - Terraform 상태 파일을 저장하는 버킷 생성
    - force_destroy : destroy할 경우 버킷 내부 객체가 남아있을 경우, 삭제 여부를 결정 (false로 설정)
    2) <b>S3 버킷 버전 관리 설정[aws_s3_bucket_versioning]</b>
    - 버킷 버저닝을 활성화함
    - 파일의 변형이나 손상을 방지하기 위함
    3) <b>S3 버킷 암호화 설정 [aws_s3_bucket_server_side_encryption_configuration]</b>
    - AES-256 알고리즘으로 .tfstate를 암호화
    - 보안 이슈
    4) <b>S3 퍼블릭 접근 차단 설정 [aws_s3_bucket_public_access_block]</b>
    - 퍼블릭 접근 차단을 비활성화하였습니다.
    - aws_s3_bucket_public_access_block을 true로 설정하면 보안을 강화할 수 있습니다.
    5) <b>S3 버킷 정책 설정 [aws_s3_bucket_policy]</b>
    - 허용된 액션
        - IAM 사용자에게 S3 버킷에 접근 허용
        - s3:GetBucketPolicy = 버킷 정책 조회
        - s3:ListBucket = 버킷 내 객체 리스트 조회
        - s3:GetObject = 객체 다운로드
        - s3:PutObject = 객체 업로드
    - 리소스에서 버킷 전체와 버킷 내 모든 파일에 대한 접근 허용
2) Terraform State Lock 설정(DynamoDB)
    1) <b>DynamoDB 테이블 생성 [aws_dynamodb_table]</b>
    - Terraform에서 apply 실행 시 동시 작업의 방지를 위한 Lock을 지원하는 DynamoDB 테이블을 사용하기 위해 생성하였습니다.
    - 주요한 설정들
        - name : 테이블 이름 지정
        - billing_mod:'PAY_PER_REQUEST' 
            - 사용한 만큼 비용 부과(요금제 설정)
        - hash_key : "LockID"
            - 주요키로 사용할 속성 설정
        - attribute
            - S타입, 즉 스트링 타입의 Lock 키 저장
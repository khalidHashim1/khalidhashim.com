Khalid Hashim Portfolio & AWS Terraform Infrastructure
======================================================

Welcome! This repository hosts my personal portfolio website and the Terraform code powering its AWS infrastructure. 

The site is deployed as a static website on S3, delivered globally via CloudFront, with Lambda functions (if any) managed via CI/CD. Terraform ensures all infrastructure is versioned, reproducible, and production-safe, while GitHub Actions automates plans and deployments only when relevant changes occur.

------------------------------------------------------

🌐 Live Site
Check out the live website here: https://khalidhashim.com

------------------------------------------------------

💻 About
I am a Computer Science graduate and AWS Cloud Engineer with hands-on experience in core AWS services including:

- S3, CloudFront, Lambda, EC2, DynamoDB, CloudWatch, SNS, Route 53, IAM, CloudFormation
- Terraform Infrastructure as Code (IaC) for portfolio automation
- CI/CD pipelines via GitHub Actions for safe deployment

This portfolio highlights my projects, cloud computing skills, automation, and scalable system design.

------------------------------------------------------

📂 Repo Structure
khalidhashim1010/

├── terraform/       # Terraform configuration for AWS infrastructure

├── frontend/        # HTML, CSS, images for the static website

├── backend/         # Lambda functions

├── .github/workflows/ # GitHub Actions workflows

└── README.md        # You are here


------------------------------------------------------

🚀 Deployment
The website and infrastructure are managed via Terraform and deployed through GitHub Actions:

- Terraform ensures reproducible infrastructure (S3, CloudFront, Route53, ACM, Lambda, etc.)
- Frontend files are synced to S3 only if there are changes
- Lambda functions updated only on relevant changes
- CloudFront invalidation happens only when needed
- AWS credentials are securely stored in GitHub Secrets

------------------------------------------------------

📬 Contact
Email: khalidhashim1422@gmail.com  
LinkedIn: https://www.linkedin.com/in/khalid-hashim-8639a7271  

© 2025 Khalid Hashim | Built with ❤️ using HTML, Tailwind CSS & AWS

Khalid Hashim Portfolio & Terraform Infrastructure

Welcome to my personal portfolio repository! This repo contains my portfolio website and Terraform infrastructure code for AWS deployment and automation.

🌐 Live Site
Check out the live website here: https://khalidhashim.com

💻 About
I am a Computer Science graduate and AWS Cloud Engineer with hands-on experience in core AWS services and Infrastructure as Code (IaC), including:

- AWS Services: S3, CloudFront, Lambda, EC2, Route 53, ACM, IAM, CloudWatch, SNS
- Infrastructure as Code: Terraform automation for provisioning, managing, and updating AWS resources
- CI/CD Automation: GitHub Actions for automated Terraform plans and deployments

📂 Repo Structure

khalidhashim1010/
├── terraform/        # Terraform files for AWS infrastructure
│   ├── main.tf       # Core resources: S3, CloudFront, Route 53, ACM
│   ├── providers.tf  # AWS provider configuration
│   └── backend.tf    # Remote state configuration
├── frontend/         # HTML, CSS, images for static website
├── backend/          # Lambda functions (if any)
├── .github/workflows/# GitHub Actions workflow for Terraform and deployment
└── README.md         # You are here

🚀 Deployment & Automation

- Frontend: Static website deployed to S3 and distributed globally via CloudFront
- Infrastructure: Managed via Terraform with remote state stored in S3
- CI/CD: GitHub Actions automates safely:
    - Terraform plan generation (manual apply recommended for production)
    - Sync frontend files to S3 only when frontend files change
    - Deploy Lambda functions (if any)
    - CloudFront cache invalidation only if website content changes

⚡ Terraform Features Highlighted

- Private S3 bucket with public access blocked
- CloudFront with Origin Access Control (OAC)
- ACM certificates with DNS validation via Route 53
- Route 53 alias records pointing to CloudFront distributions
- Safe infrastructure changes via manual approval before apply

📬 Contact
Email: khalidhashim1422@gmail.com
LinkedIn: https://www.linkedin.com/in/khalid-hashim-8639a7271

© 2025 Khalid Hashim | Built with ❤️ using HTML, Tailwind CSS & AWS + Terraform

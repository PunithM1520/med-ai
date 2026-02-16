# Docker Setup Complete! 🐳

## What's Been Created

Your Medical Chatbot is now fully Dockerized and ready to deploy on AWS EC2!

### Files Created:

1. **`Dockerfile`** - Complete Docker image configuration
2. **`docker-compose.yml`** - Easy single-command deployment
3. **`.dockerignore`** - Optimized build context
4. **`.env.example`** - Template for environment variables
5. **`DOCKER_DEPLOYMENT.md`** - Comprehensive deployment guide
6. **`deploy-ec2.sh`** - Automated EC2 deployment script

## Quick Start Summary

### Option 1: Using Docker Compose (Recommended)

```bash
# 1. Create .env file
cp .env.example .env
# Edit .env with your API keys

# 2. Build and run
docker-compose up --build -d

# 3. Access at http://localhost:8080
```

### Option 2: Using Docker CLI

```bash
docker build -t medical-chatbot:latest .

docker run -p 8080:8080 \
  -e GOOGLE_API_KEY="your-key" \
  -e PINECONE_API_KEY="your-key" \
  --name medical-chatbot \
  medical-chatbot:latest
```

### Option 3: One-Click EC2 Deployment

```bash
# On your EC2 instance:
bash deploy-ec2.sh
# Follow the prompts and enter your API keys
```

## Docker Configuration Details

### Dockerfile Includes:
- ✅ Python 3.13 slim base image (optimized for size)
- ✅ All dependencies from requirements.txt pre-installed
- ✅ Environment variable validation
- ✅ Health checks for monitoring
- ✅ Non-root user execution (security best practice)
- ✅ Proper working directory setup

### docker-compose.yml Includes:
- ✅ Automatic container management
- ✅ Port mapping (8080)
- ✅ Environment variable injection
- ✅ Volume mounting for data persistence
- ✅ Health checks
- ✅ Automatic restart policy

## Environment Variables

Set these before running:

```bash
# Google Gemini API Key
GOOGLE_API_KEY=your_google_api_key_here

# Pinecone API Key
PINECONE_API_KEY=your_pinecone_api_key_here
```

## EC2 Deployment Steps

### 1. **Launch EC2 Instance**
   - AMI: Amazon Linux 2 or Ubuntu 20.04+
   - Instance Type: t3.small (minimum recommended)
   - Storage: 20-30 GB
   - Security Group: Allow port 8080 inbound

### 2. **Connect to Instance**
   ```bash
   ssh -i your-key.pem ec2-user@your-ec2-ip
   ```

### 3. **Clone Repository**
   ```bash
   git clone <your-repo-url>
   cd <repo-name>
   ```

### 4. **Run Deployment Script**
   ```bash
   bash deploy-ec2.sh
   ```
   Or manually:
   ```bash
   # Install Docker
   sudo yum install docker -y
   sudo systemctl start docker
   
   # Setup environment
   cat > .env << EOF
   GOOGLE_API_KEY=your-key
   PINECONE_API_KEY=your-key
   EOF
   
   # Run with Docker Compose
   docker-compose up -d
   ```

### 5. **Access Chatbot**
   ```
   http://your-ec2-ip:8080
   ```

## Container Management

### View Logs
```bash
docker-compose logs -f       # Real-time logs
docker logs medical-chatbot  # Using Docker directly
```

### Stop/Start/Restart
```bash
docker-compose down           # Stop all services
docker-compose up -d          # Start
docker-compose restart        # Restart
docker restart medical-chatbot # Restart specific container
```

### Check Status
```bash
docker ps                     # Running containers
docker-compose ps             # Compose services
docker stats                  # Resource usage
```

### Rebuild Image
```bash
docker-compose up --build -d  # Rebuild and restart
```

## Production Best Practices

1. **Use .env file** (never commit to git)
   ```bash
   echo ".env" >> .gitignore
   ```

2. **Set up Nginx reverse proxy** (included in DOCKER_DEPLOYMENT.md)
   - Handles SSL/TLS
   - Load balancing
   - Better performance

3. **Enable HTTPS**
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

4. **Monitor application**
   ```bash
   docker stats medical-chatbot      # Real-time monitoring
   docker logs medical-chatbot -f    # Stream logs
   ```

5. **Setup auto-restart**
   ```yaml
   # Already configured in docker-compose.yml
   restart: unless-stopped
   ```

## Troubleshooting

### Container won't start
```bash
docker logs medical-chatbot
# Check for:
# - Missing API keys
# - Port already in use
# - Invalid credentials
```

### API authentication errors
```bash
# Verify API keys
docker exec medical-chatbot env | grep API_KEY

# Update keys and restart
docker-compose down
export GOOGLE_API_KEY="new-key"
export PINECONE_API_KEY="new-key"
docker-compose up -d
```

### Port 8080 already in use
```bash
# Find and kill process
sudo lsof -i :8080
sudo kill -9 <PID>

# Or use different port
# Edit docker-compose.yml: ports: ["8082:8080"]
```

## Included Modules & APIs

- **Flask 3.1.1** - Web framework
- **LangChain 0.3.26** - LLM orchestration
- **Google Gemini API** - Free LLM (via google-generativeai)
- **Pinecone** - Vector database for RAG
- **Sentence Transformers** - Text embeddings
- **PyPDF** - PDF document processing
- **python-dotenv** - Environment variable management
- **Werkzeug** - WSGI utilities

## File Structure in Container

```
/app/
├── app.py                    # Main Flask application
├── store_index.py            # Pinecone indexing script
├── requirements.txt          # Dependencies
├── Dockerfile                # Container image
├── docker-compose.yml        # Compose config
├── .env                      # Environment variables (do not commit)
├── templates/
│   └── chat.html            # Web UI
├── static/
│   └── style.css            # Styles
├── src/
│   ├── helper.py            # Helper functions
│   ├── prompt.py            # System prompts
│   └── __init__.py
└── data/                    # Medical PDFs (for indexing)
```

## Performance Optimization

For production, consider:
1. Use `gemini-2.0-flash` instead of `gemini-2.5-flash` (faster)
2. Increase worker processes in Flask
3. Add Redis caching layer
4. Use separate Pinecone vector store
5. Enable GZIP compression

## Cost Estimation

- **Google Gemini API**: ~$0.075 per 1M tokens (generous free tier)
- **Pinecone**: Free tier available (10M vectors)
- **EC2 t3.small**: ~$7/month
- **Total Estimated Cost**: $0-15/month with free tiers

## Next Steps

1. ✅ Get API keys from Google and Pinecone
2. ✅ Create .env file
3. ✅ Test locally with `docker-compose up`
4. ✅ Launch EC2 instance
5. ✅ Deploy using `deploy-ec2.sh` or docker-compose
6. ✅ Access and test your chatbot
7. ✅ Setup monitoring and logging

## Support Resources

- **Docker Docs**: https://docs.docker.com
- **Docker Compose**: https://docs.docker.com/compose/
- **AWS EC2**: https://docs.aws.amazon.com/ec2/
- **Google Gemini**: https://ai.google.dev
- **Pinecone**: https://docs.pinecone.io

---

**Your Medical Chatbot is ready to deploy! Deploy on EC2 in one command.** 🚀

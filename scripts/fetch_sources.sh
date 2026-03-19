#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fetch() {
  local url="$1"
  local target="$2"
  local output_path="$ROOT_DIR/$target"

  mkdir -p "$(dirname "$output_path")"
  curl -L --fail --silent --show-error "$url" -o "$output_path"
  printf 'Fetched %s\n' "$target"
}

printf 'Fetching AH reference snapshot...\n'
fetch "https://www.ah.com.sg/" "reference/ah/index.raw.html"
fetch "https://www.ah.com.sg/ResourcePackages/NUHS/assets/dist/css/bootstrap.min.css" "reference/ah/assets/css/bootstrap.min.css"
fetch "https://www.ah.com.sg/ResourcePackages/NUHS/assets/dist/css/main.min.28032024051219760.css" "reference/ah/assets/css/main.min.28032024051219760.css"
fetch "https://www.ah.com.sg/ResourcePackages/NUHS/assets/dist/css/ah.min.css" "reference/ah/assets/css/ah.min.css"
fetch "https://www.ah.com.sg/ResourcePackages/NUHS/assets/dist/js/jquery.min.js" "reference/ah/assets/js/jquery.min.js"
fetch "https://www.ah.com.sg/ResourcePackages/NUHS/assets/dist/js/bootstrap.bundle.min.js" "reference/ah/assets/js/bootstrap.bundle.min.js"
fetch "https://www.ah.com.sg/ResourcePackages/NUHS/assets/dist/js/main.min.28032024051219952.js" "reference/ah/assets/js/main.min.28032024051219952.js"
fetch "https://www.ah.com.sg/images/ahlibraries/default-album/ah.png?sfvrsn=8c4fe938_1" "reference/ah/assets/media/ah-logo.png"

printf 'Fetching NUHS@Home source pages...\n'
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home" "reference/nuhs/index.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/how-does-nuhs-home-work" "reference/nuhs/how-it-works.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/how-does-nuhs-home-work/why-choose-nuhs-home" "reference/nuhs/why-choose.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/how-does-nuhs-home-work/nuhs-home-resources" "reference/nuhs/resources.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-articles" "reference/nuhs/articles.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-events" "reference/nuhs/events.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-leadership-team" "reference/nuhs/leadership-team.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-in-the-news" "reference/nuhs/in-the-news.raw.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-articles/GetList/" "reference/nuhs/listings/articles.page-1.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-events/GetList/" "reference/nuhs/listings/events.page-1.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/GetList/" "reference/nuhs/listings/index.page-1.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-in-the-news/GetList/" "reference/nuhs/listings/in-the-news.page-1.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/nuhs-home-in-the-news/GetList/?page=2" "reference/nuhs/listings/in-the-news.page-2.html"
fetch "https://www.nuhs.edu.sg/patient-care/nuhs-at-home/how-does-nuhs-home-work/nuhs-home-resources/GetList/" "reference/nuhs/listings/resources.page-1.html"

printf 'Fetching local site assets...\n'
fetch "https://www.nuhs.edu.sg/ResourcePackages/NUHS/assets/dist/fonts/OpenSans-LightRegular-Latin.woff2" "assets/fonts/OpenSans-LightRegular-Latin.woff2"
fetch "https://www.nuhs.edu.sg/ResourcePackages/NUHS/assets/dist/fonts/OpenSans-Regular-Latin.woff2" "assets/fonts/OpenSans-Regular-Latin.woff2"
fetch "https://www.nuhs.edu.sg/ResourcePackages/NUHS/assets/dist/fonts/OpenSans-SemiBoldRegular-Latin.woff2" "assets/fonts/OpenSans-SemiBoldRegular-Latin.woff2"
fetch "https://www.nuhs.edu.sg/ResourcePackages/NUHS/assets/dist/fonts/OpenSans-BoldRegular-Latin.woff2" "assets/fonts/OpenSans-BoldRegular-Latin.woff2"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/default-album/nuhs.png?sfvrsn=a56d2935_1" "assets/media/nuhs-logo.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/default-album/icons/socialmedia_onenuhs.png?sfvrsn=b9ca0668_2" "assets/media/social-onenuhs.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/default-album/icons/socialmedia_fb.png?sfvrsn=5822fb6c_2" "assets/media/social-fb.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/default-album/icons/socialmedia_ig.png?sfvrsn=5d9d3c02_2" "assets/media/social-ig.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/default-album/icons/socialmedia_in.png?sfvrsn=c2ac9a9a_2" "assets/media/social-in.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/default-album/icons/socialmedia_x.png?sfvrsn=7ff969a5_1" "assets/media/social-x.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/default-album/icons/socialmedia_nuhplus.png?sfvrsn=c68356aa_2" "assets/media/social-nuhplus.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/heart.png?sfvrsn=364449e_1" "assets/media/service-heart.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/injection7d8a8905bf3e4b269007a68ffb767f95.png?sfvrsn=f2b16fe_3" "assets/media/service-injection.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/blood-drop.png?sfvrsn=49b60b7e_1" "assets/media/service-blood.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/monitor.png?sfvrsn=2df612ee_1" "assets/media/service-monitor.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/ambulance98e14077-5759-4e24-9569-1f22e373904e.png?sfvrsn=ba51e5dd_1" "assets/media/service-ambulance.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/family.png?sfvrsn=e67184db_1" "assets/media/benefit-family.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/house-05.png?sfvrsn=c828a49d_1" "assets/media/benefit-house.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/medical.png?sfvrsn=766aab23_1" "assets/media/benefit-medical.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/money.png?sfvrsn=61054509_1" "assets/media/benefit-money.png"
fetch "https://www.nuhs.edu.sg/images/nuhslibraries/content/patient-care/nuhs-home/banner-images/h4-1---why-choose-nuhs-at-home.jpg?sfvrsn=c814bb16_1" "assets/media/benefits-banner.jpg"
fetch "https://www.nuhs.edu.sg/docs/nuhslibraries/content-document/patient-care/nuhs-home-resources/single-page-nuhs-at-home-brochure.pdf?sfvrsn=9c856210_4" "assets/docs/nuhs-at-home-brochure.pdf"

printf 'Building local NUHS@Home mirrors...\n'
python3 "$ROOT_DIR/scripts/build_nuhs_mirror.py"

printf '\nDone. Reference source lives in reference/, mirrored pages live under patient-care/, and the landing page uses assets/.\n'

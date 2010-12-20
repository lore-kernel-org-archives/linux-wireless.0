Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56801.mail.re3.yahoo.com ([66.196.97.75]:37364 "HELO
	web56801.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755737Ab0LTLey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 06:34:54 -0500
Message-ID: <216485.77625.qm@web56801.mail.re3.yahoo.com>
Date: Mon, 20 Dec 2010 03:34:53 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 2/2] compat-wireless: unify some driver-select colors
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

unify driver-select colors for better user screen readbility

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -45,7 +45,7 @@ fi
 SUPPORTED_ETH_DRIVERS=""
 
 function usage {
-	echo -e "${GREEN}Usage${NORMAL}: ${CYAN}$0${NORMAL} [ ${PURPLE}<driver-name>${NORMAL} | ${PURPLE}<driver-group-name>${NORMAL} | ${GREEN}restore${NORMAL} ]"
+	echo -e "${GREEN}Usage${NORMAL}: ${BOLD}$0${NORMAL} [ ${PURPLE}<driver-name>${NORMAL} | ${CYAN}<driver-group-name>${NORMAL} | ${GREEN}restore${NORMAL} ]"
 
 	# These should match the switch below.
 	echo -e "Supported 802.11 drivers:"
@@ -64,8 +64,8 @@ function usage {
 	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
 	
 	echo -e "\nSupported group drivers: Bluetooth & Ethernet:"
-	echo -e "\t${BLUE}atlxx${NORMAL} < ${PURPLE} atl1 atl2 atl1e atl1c ${NORMAL}>"
-	echo -e "\t${BLUE}bt${NORMAL} < ${PURPLE} Linux bluetooth drivers ${NORMAL}>"
+	echo -e "\t${CYAN}atlxx${NORMAL} < ${PURPLE} atl1 atl2 atl1e atl1c ${NORMAL}>"
+	echo -e "\t${CYAN}bt${NORMAL} < ${PURPLE} Linux bluetooth drivers ${NORMAL}>"
 
 	echo -e "Restoring compat-wireless:"
 	echo -e "\t${GREEN}restore${NORMAL}: you can use this option to restore compat-wireless to the original state"



      

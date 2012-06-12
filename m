Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11-vm3.bullet.mail.sg3.yahoo.com ([106.10.148.242]:43764 "HELO
	nm11-vm3.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752843Ab2FLRR0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 13:17:26 -0400
Message-ID: <1339521048.8774.YahooMailNeo@web192304.mail.sg3.yahoo.com> (sfid-20120612_191731_777652_D5931B27)
Date: Wed, 13 Jun 2012 01:10:48 +0800 (SGT)
From: Dino Joseph Mycle <dinomycle@yahoo.com>
Reply-To: Dino Joseph Mycle <dinomycle@yahoo.com>
Subject: TDLS implementation clarifications
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello all,

   I want to know more about the TDLS implementation. According to IEEE 
802.11z(http://standards.ieee.org/news/2011/80211z.html) which is 
incorporated to IEEE 802.11-2012 document. It says that "A TDLS direct link is set up automatically, without need for user 
intervention, while the connection with the AP is maintained". But in the mac80211 we need to configure the peer mac to make it work(using 
wpa_supplicant), so as said by IEEE, without the need for user 
intervention spec is not met right ?

Can someone throw some light into the TDLS feature in linux and the future road map. 

Thanks for the help,
Dino Joseph Mycle

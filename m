Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm28-vm6.bullet.mail.sg3.yahoo.com ([106.10.151.149]:33827 "EHLO
	nm28-vm6.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaDDBzm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2014 21:55:42 -0400
Message-ID: <1396576540.65047.YahooMailBasic@web193505.mail.sg3.yahoo.com> (sfid-20140404_035612_924490_58E9FE24)
Date: Fri, 4 Apr 2014 09:55:40 +0800 (SGT)
From: sandeep suresh <sandeep.suresh@yahoo.co.in>
Subject: Wifi client Bluetooth coexistence; non smooth video streams
To: Adrian Chadd <adrian@freebsd.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1396276552.27791.YahooMailBasic@web193503.mail.sg3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,
   Please help if any one have encountered simillar problems or other guidance on this, Please.

The following is my set-up:
Linksys Access point. Cisco 802.11g camera connected as a wifi client to Linksys. I have a development board in which i have AR9287 as the Wifi chipset associated as wifi client to linksys. The development board has Bluetooth dongle for streaming audio etc. The development board has a LCD display and I stream the video stream from camera at 640 x 480 resolution, MPEG-4, 10fps (also tried with 15, 30 fps).

Software: For the Wifi client on the development board, I am using the ath9k driver with btcoex_enable=1.
2-wire coexistence. I am allowing 40% of the time for Bluetooth an 60% of the time for WiFi. The period is around 200ms.

Observations: 
1. The video streams are not smooth. There will be a small pause of a second or two between frames and hence we do not see smooth transitions.
2. Sometimes it looks like, the streams are bufferred and played back at a rapid pace. So, one can see like a fast forward play of video streams on the board.
3. Disabling coexistence does not have these observations.
Please help.
Regards
Sandeep.

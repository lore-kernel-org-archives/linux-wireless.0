Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:42504 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751459AbYKIGBF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 01:01:05 -0500
Date: Sun, 9 Nov 2008 06:01:03 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: throughput problem Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <349181.30158.qm@web23105.mail.ird.yahoo.com> (sfid-20081109_070111_999325_F2E6CAD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without any additional modification, just compat-wireless and wireles-testing v2.6.28-rc3-4651-gb53846d has a preculiar problem - the rate is
stuck at 54Mb (known issue to be addressed by Herton's feedback patch) as shown by iwconfig, but sftp doesn't transfer file much higher than 30-40kB/s.
blowing away /lib/module/`uname -r`/updates (i.e. reverting to the as shipped 2.6.27.5 rtl8187 & mac80211 ) gives easily over 10 times that
speed. anybody seen this problem (with rtl8187 or other mac80211 driver 
with wireless testing)?


      

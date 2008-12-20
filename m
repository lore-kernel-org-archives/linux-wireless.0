Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46]:29473 "HELO
	web23106.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752267AbYLTBjQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 20:39:16 -0500
Date: Sat, 20 Dec 2008 01:32:34 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: throughput problem with rtl8187B within last few days (again)?
To: herton@mandriva.com.br, Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <692008.7538.qm@web23106.mail.ird.yahoo.com> (sfid-20081220_023921_205944_33C2B8D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using v2.6.28-rc8-8109-g6ec77a1 (about 3 days old, 2008-12-17/12-18 thereabouts) and transferring some files across and the throughput is back to about 50KB/s again - should be about 10x - and iwconfig stays at 1Mbit; doing iwconfig rate other numbers doesn't change anything.

I am tracking wireless testing quite regularly so if it breaks, the breakage hasn't been more than a week, I think; one thing I am not sure about is that I am running "mke2fs -c -c " on a USB disk on the same hub (it is a laptop so it is a "logical" hub) at the moment. So I am wondering if anything breaks in the last few days, or other USB activities can seriously affect the driver. 

I'll try again and write again when the mke2fs -c -c finishes (about 30 hours for 250GB). Meanwhile, either of you want to say anything?

Hin-Tak


      

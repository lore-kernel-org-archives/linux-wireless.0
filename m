Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46]:24736 "HELO
	web23106.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752484AbYKFBCY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 20:02:24 -0500
Date: Thu, 6 Nov 2008 01:02:22 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <491237C1.4090701@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <231945.17136.qm@web23106.mail.ird.yahoo.com> (sfid-20081106_020226_968344_2A276EED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 6/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On my system is started at 1 Mbs and rapidly moved to
> 54Mbs. It went so quickly
> that by the time I started a ping, switched terminals, and
> issued an ivconfig,
> it was already at 54 Mbs.

Okay, I was writing too soon. My rate does go up and down now (pinging the other end of the wireless link, it varies between 12Mb to 36Mb). I don't know why it was stuck at 1Mb for a while earlier (10-20 minutes while I was doing a fair bit of web browsing, etc), nor why it is go up and down now :-(. 

Hin-Tak 



      

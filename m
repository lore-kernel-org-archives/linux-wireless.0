Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:20914 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753069AbYKFBgc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 20:36:32 -0500
Date: Thu, 6 Nov 2008 01:36:29 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <491237C1.4090701@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <968895.35316.qm@web23104.mail.ird.yahoo.com> (sfid-20081106_023636_758773_88264D45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 6/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On my system is started at 1 Mbs and rapidly moved to
> 54Mbs. It went so quickly
> that by the time I started a ping, switched terminals, and
> issued an ivconfig,
> it was already at 54 Mbs.

Seems that in my situation (my access point is a slow machine), the behavior of the rate control mechanism depends on the *type* of work load - I was restoring a firefox session with a lot of windows, and it is stuck at 1Mb all the time. But once all the windows are stored, doing a ping I can indeed have the rate going up (and eventually coming down) to 24-36Mb.

Hin-Tak


      

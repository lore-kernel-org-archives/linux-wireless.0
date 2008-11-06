Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60929 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbYKFBnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 20:43:07 -0500
Message-ID: <49124B87.7050901@lwfinger.net> (sfid-20081106_024314_121096_25F9F281)
Date: Wed, 05 Nov 2008 17:42:31 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
 using tx close descriptor for 8187B
References: <968895.35316.qm@web23104.mail.ird.yahoo.com>
In-Reply-To: <968895.35316.qm@web23104.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> Seems that in my situation (my access point is a slow machine), the behavior of the rate control mechanism depends on the *type* of work load - I was restoring a firefox session with a lot of windows, and it is stuck at 1Mb all the time. But once all the windows are stored, doing a ping I can indeed have the rate going up (and eventually coming down) to 24-36Mb.

Are those default pings? It may work differently with those short packets thaqn
it does with the longer ones found with browsing.

Larry

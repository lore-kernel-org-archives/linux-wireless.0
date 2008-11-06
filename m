Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23103.mail.ird.yahoo.com ([217.146.189.43]:34465 "HELO
	web23103.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751870AbYKFEXL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 23:23:11 -0500
Date: Thu, 6 Nov 2008 04:23:08 +0000 (GMT)
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
In-Reply-To: <49124B87.7050901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <266243.34099.qm@web23103.mail.ird.yahoo.com> (sfid-20081106_052316_499246_B5CE1833)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 6/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hin-Tak Leung wrote:
> > 
> > Seems that in my situation (my access point is a slow
> machine), the behavior of the rate control mechanism depends
> on the *type* of work load - I was restoring a firefox
> session with a lot of windows, and it is stuck at 1Mb all
> the time. But once all the windows are stored, doing a ping
> I can indeed have the rate going up (and eventually coming
> down) to 24-36Mb.
> 
> Are those default pings? It may work differently with those
> short packets thaqn
> it does with the longer ones found with browsing.

Yes, just default "ping 192.168.0.1" without any options. I wonder if
pid is clever enough to work out that my upstream bandwidth is only 2Mb/s (web browsing obviously goes outside) and not letting it go over 1Mb/s.

Also wondering about latency: in the absence of browser traffic, I can ping the AP/routing-machine with 0.07s round-trip time, but it increases to almost 2s when restoring a firefox session. I tried to see if pinging - which is between the client and the AP - changes the rate, compared to firefox which depends on limited upstream bandwidth. It didn't, and given how poor ping works during such time, it isn't surprising.

Hin-Tak

 


      

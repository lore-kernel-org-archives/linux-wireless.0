Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:60503 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZELLIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 07:08:54 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1M3paY-0004nG-GO
	for linux-wireless@vger.kernel.org; Tue, 12 May 2009 12:51:58 +0200
Date: Tue, 12 May 2009 12:39:03 +0200
From: Evgeni Golov <sargentd@die-welt.net>
To: Jiri Slaby
	<public-jirislaby-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>
Cc: Justin Mattock
	<public-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
	Linux Kernel Mailing List
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	public-ath9k-devel-xDcbHBWguxHbcTqmT+pZeQ@hugh.gmane.org,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
In-Reply-To: <4A089E49.7080403@gmail.com>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	<4A089E49.7080403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20090512103905.0D68E1FD10@chi.die-welt.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Mon, 11 May 2009 23:53:13 +0200 Jiri Slaby wrote:

> > in dmesg I see:
> > 
> > [   36.337419] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
> > [   36.530106] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
> > [   36.730100] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
> > [   36.930101] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
> > [   44.421728] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
> > [   44.620080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
> > [   44.820080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
> > [   45.020076] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
> > 
> > The type of encryption used is just
> > a standard WEP key(no WPA).

Same here with 2.6.30-rc4, b43 and either Cisco (MAC-Addr starts with
00:40:96) or HP ProCurve (??? - they do WiFi? - MAC-Addr starts with
00:1F:FE) APs. No encryption, quite noisy environment (University).

No problem with ipw2200 (actually 2915) in the same hardware (Thinkpad
X31). Neither with the b43 and a standard Linksys WRT54GL (in the same!
noisy university-env).

Regards
Evgeni


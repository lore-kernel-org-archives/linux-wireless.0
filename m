Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37186
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbXG0JWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:22:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Woodhouse <dwmw2@infradead.org>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Date: Fri, 27 Jul 2007 11:20:13 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <46A8ECD6.30204@lwfinger.net> <1185527932.14697.535.camel@pmac.infradead.org>
In-Reply-To: <1185527932.14697.535.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707271120.13723.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 July 2007 11:18:52 David Woodhouse wrote:
> I still get constant complaints of 'eth1: duplicate address detected'
> due to the fact that it sees its own outgoing packets, and IPv6 doesn't
> work.
> 
> Then when unloading the module I get...
> 
> bcm43xx_mac80211: Radio turned off
> Freeing alive inet6 address c1cefc80
> unregister_netdevice: waiting for eth1 to become free. Usage count = 2

Sounds like mac80211 problems.
Jiri, Michael?


-- 
Greetings Michael.

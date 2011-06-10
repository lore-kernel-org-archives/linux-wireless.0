Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:48033 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758103Ab1FJWZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 18:25:11 -0400
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: wwguy <wey-yi.w.guy@intel.com>
Subject: Re: iwlagn module ignores parameter "led_mode=1" under certain conditions
Date: Sat, 11 Jun 2011 00:25:05 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <201106100937.23295.toralf.foerster@gmx.de> <1307719540.5115.25.camel@wwguy-ubuntu>
In-Reply-To: <1307719540.5115.25.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106110025.06740.toralf.foerster@gmx.de> (sfid-20110611_002515_327826_5B90DE7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


wwguy wrote at 17:25:40
> On Fri, 2011-06-10 at 00:37 -0700, Toralf Förster wrote:
> > Hello,
> > 
> > Since years this worked at my Gentoo system :
> > 
> > $ cat /etc/modprobe.d/iwlagn.conf
> > options iwlcore led_mode=1
> > 
> > However nowadays this doesn't work when I do the following :
> > 
> > 1. dock the ThinkPad T400 (no WLAN, only DSL)
> > 2. boot it
> > 3. s2ram it
> > 4. undock it
> > 5. go into the office
> > 6. resume the undocked notebook (WLAN, no DSL)
> > 
> > The led is blinking ...
> > 
> > Putting however this line into the config file :
> > $ options iwlagn  led_mode=1
> > 
> > works always.
> 
> what kernel version you are using?
2.6.39.1 and I'm just curious b/c if I boot the system within the office than 
the old line works fine.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

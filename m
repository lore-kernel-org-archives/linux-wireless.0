Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33704 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613AbZC1Os3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 10:48:29 -0400
Date: Sat, 28 Mar 2009 11:48:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill/rfkill-input userspace API
Message-ID: <20090328144823.GA6420@khazad-dum.debian.net> (sfid-20090328_154832_265198_DC87C3F4)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> <20090327221147.GA499@srcf.ucam.org> <20090328123645.GD7439@khazad-dum.debian.net> <20090328124719.GF7439@khazad-dum.debian.net> <20090328125301.GA26537@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090328125301.GA26537@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Mar 2009, Matthew Garrett wrote:
> On Sat, Mar 28, 2009 at 09:47:19AM -0300, Henrique de Moraes Holschuh wrote:
> > > Eh? What is that ioctl in the git version doing there, then?  Did I
> > > get the code from the wrong branch or something?
> > 
> > Ok, more on this: the ioctl _is_ needed for privacy reasons, it wasn't
> > added there just for the kick of it AFAIK.  Instead of just breaking
> > things the other way, can we configure evdev to sometimes do the grab,
> > and sometimes not, depending on a config option for that particular
> > device? 
> 
> No it's not. The event devices are only readable by root, and root can 
> get your keypresses anyway.

I can live with that.  Very well, I will hunt down what version of
evdev we have in Debian stable and unstable, what version of evdev
stopped doing grab-by-default, and document this in a few places.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

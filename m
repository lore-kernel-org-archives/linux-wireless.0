Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39600 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZDSSPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 14:15:05 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Marcel Holtmann <marcel@holtmann.org>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419180314.23710@gmx.net>
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net>
	 (sfid-20090419_160555_446977_A429511B) <1240150277.898.7.camel@johannes.local>
	 <20090419151629.158790@gmx.net>
	 (sfid-20090419_171702_263242_9A8C16F9) <1240154704.898.18.camel@johannes.local>
	 <20090419155319.158810@gmx.net>
	 (sfid-20090419_175352_161479_A88396A3) <1240156631.917.1.camel@johannes.local>
	 <20090419161316.158790@gmx.net>
	 (sfid-20090419_181324_681308_BAEAE072) <1240158381.917.21.camel@johannes.local>
	 <20090419165443.158820@gmx.net>
	 (sfid-20090419_185516_519795_36D34B9B) <1240160241.28138.4.camel@johannes.local>
	 <20090419173354.158790@gmx.net> <1240163391.11795.59.camel@violet>
	 <20090419180314.23710@gmx.net>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 20:14:55 +0200
Message-Id: <1240164895.11795.70.camel@violet> (sfid-20090419_201510_612001_9B6EE001)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alina,

> > you argue command line tools against kernel exposed API.
> 
> I use the command line syntax to explain the kernel API.

and that is just plain wrong to begin with. If you want a one command do
everything, then do that in userspace and not inside a kernel API.

> > Both have
> > nothing to do with each other on that level.
> 
> Most commands are mapped 1:1. And the API easier to understand if it is so.

That just happen to be this way right now. It doesn't have to stay that
way and if it would, that would be actually be stupid.

> > If you don't like the iw
> > syntax then fix it and provide a command that does all three task for
> > you. No need to mess with the kernel interface for that.
> 
> I think now, provide a high-level command besides the low-level commands is a good idea. We need it for the old wext interface anyway. Then wext can only call this command and don't need own intelligence. So than it's only a foolish wrapper, like it should.

>From my point of view, WEXT can die right now. Just doing something to
make WEXT happy is wrong. If you want something like that then do it in
userspace. I just don't see the need here for an extra kernel API.

Regards

Marcel



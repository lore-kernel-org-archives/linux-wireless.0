Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53331 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZDSTbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 15:31:25 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Marcel Holtmann <marcel@holtmann.org>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419184320.158810@gmx.net>
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
	 <20090419180314.23710@gmx.net> <1240164895.11795.70.camel@violet>
	 <20090419184320.158810@gmx.net>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 21:31:15 +0200
Message-Id: <1240169475.11795.79.camel@violet> (sfid-20090419_213129_385614_54F04B3D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alina,

let me repeat what Johannes mentioned earlier, please don't send emails
twice. Just use a proper working MUA and do Reply-All.

> > and that is just plain wrong to begin with. If you want a one command do
> > everything, then do that in userspace and not inside a kernel API.
> 
> Then why not implement deferent syscalls for floppy disks, hard disk drives, solid state disks and normal files? If you want one generic API than write an users-space library.
> 
> Thought-out APIs sucks, MS-DOS rules!

you are seriously comparing block devices to network device now? They
are different, go figure. You better bring technical arguments that
matter and not something far fetched from a total different technology.

> > >>From my point of view, WEXT can die right now. Just doing something to
> > make WEXT happy is wrong. If you want something like that then do it in
> > userspace. I just don't see the need here for an extra kernel API.
> 
> There is no concept, what should be in user-space and what not. It's all mixed together. Not a microkernel, no a monolithic kernel, awful.

Actually there is a clear thing here. No policy inside the kernel. So no
stupid magic between ad-hoc and managed mode. The userspace has to make
the decision what it wants to do. The kernel just executes it.

Regards

Marcel



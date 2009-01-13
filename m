Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:34434 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZAMQLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 11:11:48 -0500
Date: Tue, 13 Jan 2009 14:11:29 -0200
From: Werner Almesberger <werner@openmoko.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Hans Henry von Tresckow <hvontres@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
Message-ID: <20090113161129.GB22112@almesberger.net> (sfid-20090113_171153_465406_2EA4CBD6)
References: <20090112191514.GA22112@almesberger.net> <a7f8874a0901121131m75ffa5e0o246dee810eb29983@mail.gmail.com> <20090113131422.GA27676@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090113131422.GA27676@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> If you kick it out of the bus (cause a full hotunplug on rfkill block,
> and a hotplug when rfkill unblocks), it is userspace.
> 
> But what if you do it halfway?   That's what is being asked here...

If kicking it out of the bus is okay, then that's just what I'll
do. This gives us clear and familiar semantics and avoids complex
and fragile state preservation in the kernel.

My concern about this was whether this wouldn't take things too
far. E.g., if I can safely assume that user space will be there
to take care of it.

>From what I gather, it does indeed seem to be acceptable, even if
it may not be ideal under all circumstances.

Thanks,
- Werner

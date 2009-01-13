Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55646 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbZAMU4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 15:56:51 -0500
Date: Tue, 13 Jan 2009 18:56:46 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Werner Almesberger <werner@openmoko.org>
Cc: Hans Henry von Tresckow <hvontres@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
Message-ID: <20090113205646.GA17214@khazad-dum.debian.net> (sfid-20090113_215655_519104_AD009FE2)
References: <20090112191514.GA22112@almesberger.net> <a7f8874a0901121131m75ffa5e0o246dee810eb29983@mail.gmail.com> <20090113131422.GA27676@khazad-dum.debian.net> <20090113161129.GB22112@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090113161129.GB22112@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 Jan 2009, Werner Almesberger wrote:
> Henrique de Moraes Holschuh wrote:
> > If you kick it out of the bus (cause a full hotunplug on rfkill block,
> > and a hotplug when rfkill unblocks), it is userspace.
> > 
> > But what if you do it halfway?   That's what is being asked here...
> 
> If kicking it out of the bus is okay, then that's just what I'll
> do. This gives us clear and familiar semantics and avoids complex
> and fragile state preservation in the kernel.

Yes, it is okay.  It has to be, many devices absolutely require it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

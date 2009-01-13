Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53712 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759351AbZAMNO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:14:27 -0500
Date: Tue, 13 Jan 2009 11:14:22 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Hans Henry von Tresckow <hvontres@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
Message-ID: <20090113131422.GA27676@khazad-dum.debian.net> (sfid-20090113_141449_317140_087D6162)
References: <20090112191514.GA22112@almesberger.net> <a7f8874a0901121131m75ffa5e0o246dee810eb29983@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a7f8874a0901121131m75ffa5e0o246dee810eb29983@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 12 Jan 2009, Hans Henry von Tresckow wrote:
> As an interested User/lurker, it seems that allowing rfkill to power
> down as much of the device as possible in the "killed" state would be
> desirable. This would help extend battery life when wifi is not
> needed. It seems reasonable to assume that the interface would need
> reconfiguring once the rfkill switch is turned back on.

Agreed, but the real question is not that.

It is "who is responsible for restoring the interface state, and to
what extent"?

If you kick it out of the bus (cause a full hotunplug on rfkill block,
and a hotplug when rfkill unblocks), it is userspace.

But what if you do it halfway?   That's what is being asked here...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

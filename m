Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:36122 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbIPVKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 17:10:25 -0400
Received: by igcxw12 with SMTP id xw12so161649igc.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 14:10:25 -0700 (PDT)
Date: Wed, 16 Sep 2015 17:10:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Brady Lyles <lyles.brady@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: lenovo t400 atheros ar242x ath5k bug
Message-ID: <20150916211006.GB3066@localhost> (sfid-20150916_231028_765922_5603EEA7)
References: <CANR9swOiEVT6PvKv0V1Ytwm0GsN0_2HXqFpdmGAPzFoQG5T2Cg@mail.gmail.com>
 <20150806161958.GA20514@localhost>
 <CANR9swMSvdSOcC+HyYp2JbHBh8m2puZb04NpVafHuKmHkxWSqA@mail.gmail.com>
 <CANR9swNoQkh6mSkiYncEzqCzcdrD3cFW74Ld=Hj6CkBJ0Zp+CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANR9swNoQkh6mSkiYncEzqCzcdrD3cFW74Ld=Hj6CkBJ0Zp+CQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Please don't top-post.  Reordered it somewhat.)

On Wed, Sep 16, 2015 at 02:19:12PM -0600, Brady Lyles wrote:
> wondering if there are any more questions/suggestions to resolve this issue?
> Thank you!
> >
> >> My wild guess (not being too familiar with qubes) is that passthrough is not
> >> working properly -- this:
> >>
> >>> [    5.401276] BUG: unable to handle kernel paging request at ffffc90000900014
> >>> [    5.401287] IP: [<ffffffff81268928>] iowrite32+0x38/0x40
>
> >> ...looks like a pci write to an unusual address.
> >>
> >> What does output of lspci -vnn look like, run as root in the guest?

> > 00:01.0 Ethernet controller [0200]: Qualcomm Atheros AR242x / AR542x
> > Wireless Network Adapter (PCI-Express) [168c:001c] (rev 01)
> >     Subsystem: Qualcomm Atheros Device [168c:0035]
> >     Flags: bus master, fast devsel, latency 0, IRQ 39
> >     Memory at f4300000 (64-bit, non-prefetchable) [size=64K]

(Regarding running inside Qubes / Xen...)

Unfortunately the VM / PCI passthrough stuff is outside my small area of
expertise, perhaps someone else knows?

-- 
Bob Copeland %% http://bobcopeland.com/

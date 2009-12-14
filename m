Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48044 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbZLNS0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 13:26:11 -0500
Received: by ewy19 with SMTP id 19so3685938ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 10:26:09 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 19:24:47 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200912141559.29282.bzolnier@gmail.com> <200912141720.11465.bzolnier@gmail.com> <20091214.100345.57458443.davem@davemloft.net>
In-Reply-To: <20091214.100345.57458443.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200912141924.47370.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009 07:03:45 pm David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 14 Dec 2009 17:20:11 +0100
> 
> > Well, in theory all maintainers should be testing -next kernels
> > so nothing should change also in this regard.
> 
> You conveniently did not quote and respond to my comments showing that
> you can ask git tools to seperate out the changesets for you, regardless
> of what subsystem maintainers decide to do.
> 
> Power is in your hands, really. :-)

That is simply untrue from Linus' kernel point of view.

Each networking merge contains multiple sub-merges from wireless tree
(at random points in networking tree history) which in turn may contain
multiple sub-merges from Johannes (at random points in wireless tree
history) and wireless driver sub-projects so unless you are a hardcore
networking/wireless developer it is practically impossible to make
a sense out of it in a reasonable time.

--
Bartlomiej Zolnierkiewicz

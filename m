Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:38937 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYBSVDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 16:03:11 -0500
Received: by nf-out-0910.google.com with SMTP id g13so742897nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2008 13:03:07 -0800 (PST)
To: chris2553@googlemail.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Tue, 19 Feb 2008 22:03:03 +0100
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802192046.14184.IvDoorn@gmail.com> <200802192044.52327.chris2553@googlemail.com>
In-Reply-To: <200802192044.52327.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802192203.03741.IvDoorn@gmail.com> (sfid-20080219_210316_638863_9CA127C1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > I've tried the patch but, unfortunately, my wireless LAN still dies after a few pings.
> > 
> > Could you use below patch instead, and make a new dump of the register?
> > I'm still convinced the breakage occurs in the antenna diversity (or rather, I believe
> > it attempts a software diversity for your card while in fact it shouldn't).
> > 
> 
> Sorry, I've applied that patch and the LAN still dies after a few pings. BTW,

> this and the earlier patch both apply without error, but give warnings of 70
> line offsets. Were you expecting them to apply completely cleanly? I'm just
> wondering if there might be some code that you are expecting to be running (or
> not running) that is (or is not) present in the driver at 2.6.25-rc2.

Well to be honest I based the patch on rt2x00.git and not 2.6.25-rc2.
I know the patch would apply safely because the function that were changed
in that patch haven't changed between them. But some other functions were
moved. So that offset is correct. ;)

> The register dumps before and after are attached.

Thanks. I hope to have a new patch ready soon.

Ivo


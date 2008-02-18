Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:53766 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYBRSQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 13:16:30 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1948207fkz.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 10:16:27 -0800 (PST)
To: "Chris Clayton" <chris2553@googlemail.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Mon, 18 Feb 2008 19:16:12 +0100
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802181911.32128.IvDoorn@gmail.com>
In-Reply-To: <200802181911.32128.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802181916.12746.IvDoorn@gmail.com> (sfid-20080218_181634_729728_F5C0DBFB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Almost forgot:

> > In 2.6.25 kernels, my wireless LAN dies after even the smallest amount
> > of network activity. The following screen cut shows what I typically
> > see:
> 
> How complete is this failure? Just TX or also RX?
> 
> Could you use the tools found here:
> http://www-user.rhrk.uni-kl.de/~nissler/rt2x00/index.html
> 
> and capture all TX/RX frames going through the hardware?
> Note that after the failure, this dumping facitilty should still report
> any ping request you might send to the interface.

Note that this feature is only present in 2.6.25.

> I have a series of tests I would like to request from you,
> you mentioned you already enabled debugfs, and that is just what we need. ;)
> Please use attached script to create dumps of the hardware register contents.

The debugfs register files were moved into a seperate folder somewhere between
2.6.24 and 2.6.25. This means you might have to edit the file slightly to make it
point to the correct location of the chipset file.

Ivo

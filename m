Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0KLGs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 01:48:26 -0500
Received: by bwz15 with SMTP id 15so2751187bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 22:48:25 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tim Blechmann <tim@klingt.org>
Subject: Re: rt61pci issue
Date: Fri, 12 Nov 2010 07:47:28 +0100
Cc: linux-wireless@vger.kernel.org
References: <ibgpgg$a5m$1@dough.gmane.org> <201011111556.31601.tim@klingt.org> <AANLkTikqx43LwfyB4979Mazhch41cGaa7txP6zjCa99F@mail.gmail.com>
In-Reply-To: <AANLkTikqx43LwfyB4979Mazhch41cGaa7txP6zjCa99F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011120747.28837.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 11 November 2010 schrieb Helmut Schaa:
> On Thu, Nov 11, 2010 at 3:56 PM, Tim Blechmann <tim@klingt.org> wrote:
> >> Mind to put a (maybe rate limited) printk into the interrupt thread
> >> that prints out "reg"
> >> and "reg_mcu" so that we can see which interrupts get triggered?
> >
> > log attached, generated with:
> 
> Thanks. Unfortunately nothing special in there. Mostly RX and TX interrupts. So
> there must be something else ...

Tim, is this on x86 hw? Or something else?

Helmut

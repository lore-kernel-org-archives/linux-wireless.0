Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37394 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0KKPNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 10:13:31 -0500
Received: by ywo7 with SMTP id 7so64066ywo.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 07:13:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011111556.31601.tim@klingt.org>
References: <ibgpgg$a5m$1@dough.gmane.org>
	<AANLkTikLoz-7LuhkcuRWGr+he+S3D=K_tmVHcmj3AZ-O@mail.gmail.com>
	<201011111556.31601.tim@klingt.org>
Date: Thu, 11 Nov 2010 16:13:25 +0100
Message-ID: <AANLkTikqx43LwfyB4979Mazhch41cGaa7txP6zjCa99F@mail.gmail.com>
Subject: Re: rt61pci issue
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 3:56 PM, Tim Blechmann <tim@klingt.org> wrote:
>> Mind to put a (maybe rate limited) printk into the interrupt thread
>> that prints out "reg"
>> and "reg_mcu" so that we can see which interrupts get triggered?
>
> log attached, generated with:

Thanks. Unfortunately nothing special in there. Mostly RX and TX interrupts. So
there must be something else ...

Helmut

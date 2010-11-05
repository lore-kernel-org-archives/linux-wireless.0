Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0KEICx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 04:02:53 -0400
Received: by fxm16 with SMTP id 16so2126900fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 01:02:52 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 05/13] rt2x00: Add unlikely to skb allocation failure check
Date: Fri, 5 Nov 2010 09:01:59 +0100
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201011042037.00178.IvDoorn@gmail.com> <201011050823.48982.helmut.schaa@googlemail.com> <AANLkTik145p=rQraC1pGHM6Rrs2hOjPiSQqq6hN3o7Wt@mail.gmail.com>
In-Reply-To: <AANLkTik145p=rQraC1pGHM6Rrs2hOjPiSQqq6hN3o7Wt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011050901.59251.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 05 November 2010 schrieb Rafał Miłecki:
> 2010/11/5 Helmut Schaa <helmut.schaa@googlemail.com>:
> > Interesting, didn't know that. I've just given it a try and the MIPS assembly
> > indeed stays the same with and without the unlikely. Nevertheless, I've found
> > quite a number of unlikely(!x) checks throughout the net stack ...
> 
> What do you mean by x? AFAIU gcc optimization is only for pointers. If
> x is some int (bool), it still has affect.

I meant x to be a pointer, yes.

Helmut

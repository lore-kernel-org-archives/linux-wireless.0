Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52492 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0KEHwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 03:52:02 -0400
Received: by qwb8 with SMTP id 8so215472qwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 00:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201011050823.48982.helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com>
	<201011042038.35919.IvDoorn@gmail.com>
	<AANLkTi=1eHFOX5S6H_ZETWoXz_8nm5Xd+hExrRWX7go8@mail.gmail.com>
	<201011050823.48982.helmut.schaa@googlemail.com>
Date: Fri, 5 Nov 2010 08:52:01 +0100
Message-ID: <AANLkTik145p=rQraC1pGHM6Rrs2hOjPiSQqq6hN3o7Wt@mail.gmail.com>
Subject: Re: [PATCH 05/13] rt2x00: Add unlikely to skb allocation failure check
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/5 Helmut Schaa <helmut.schaa@googlemail.com>:
> Interesting, didn't know that. I've just given it a try and the MIPS assembly
> indeed stays the same with and without the unlikely. Nevertheless, I've found
> quite a number of unlikely(!x) checks throughout the net stack ...

What do you mean by x? AFAIU gcc optimization is only for pointers. If
x is some int (bool), it still has affect.

-- 
Rafał

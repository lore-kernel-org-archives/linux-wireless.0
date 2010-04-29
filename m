Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:48061 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262Ab0D3St6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:49:58 -0400
Received: by fg-out-1718.google.com with SMTP id d23so225224fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Apr 2010 11:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004282252.07424.pedrogfrancisco@gmail.com>
References: <201004230806.13628.pedrogfrancisco@gmail.com>
	 <q2p19f34abd1004240509r63449b41l379bc14f5c6eaeae@mail.gmail.com>
	 <201004241828.37489.pedrogfrancisco@gmail.com>
	 <201004282252.07424.pedrogfrancisco@gmail.com>
Date: Thu, 29 Apr 2010 09:17:00 +0200
Message-ID: <p2z19f34abd1004290017sd2379471q67917514161b1133@mail.gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: me@bobcopeland.com, "John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> A Sexta, 23 de Abril de 2010 17:37:03 me@bobcopeland.com escreveu:
> -snip
>> Advice for debugging: turn on slub/slab debug options, and possibly
>> kmemcheck.  kmemcheck was very helpful for me last time I had such
>> a corruption issue.
>
> I can't seem to find the "kmemcheck: trap use of uninitialized memory" option
> in make menuconfig, section Kernel Hacking, though a search shows it should be
> there.

Most likely you need to disable "Optimize for size", under "General
setup" in the main menu to make it appear. But it could also be one of
the other dependencies; check the "Depends on" line of KMEMCHECK when
you do the search.


Vegard

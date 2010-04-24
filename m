Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58920 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0DXMJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Apr 2010 08:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <201004240956.45899.pedrogfrancisco@gmail.com>
References: <201004230806.13628.pedrogfrancisco@gmail.com>
	 <20100423134823.GB5004@tuxdriver.com>
	 <20100423163703.GB11112@hash.localnet>
	 <201004240956.45899.pedrogfrancisco@gmail.com>
Date: Sat, 24 Apr 2010 14:09:20 +0200
Message-ID: <q2p19f34abd1004240509r63449b41l379bc14f5c6eaeae@mail.gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: me@bobcopeland.com, "John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 April 2010 10:56, Pedro Francisco <pedrogfrancisco@gmail.com> wrote:
> For some reason I am unable to get a kernel I compiled to boot. Since I was
> unable to compile the kernel with those debugging options, I just turned on
> slub_debug on GRUB.
>
> I got a few messages which I pasting here only partially to check for their
> significance. If significant I'll post them fully:

Please post all the info you have. Full crash log and full slub-debug
report are both very interesting.

Not sure what exactly linux-backports-modules-wireless-lucid-generic
is, but one way to narrow it down is to NOT use that and see if it
still crashes.

You might find your distro config in /boot/config-*; you could copy
that to .config in your kernel directory and try to compile (and boot)
a more recent kernel with that.

Good luck,


Vegard

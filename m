Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40756 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3CFHcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 02:32:23 -0500
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <20790.61609.875201.57288@gargle.gargle.HOWL> (sfid-20130306_083228_969398_548332AE)
Date: Wed, 6 Mar 2013 13:00:49 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Nick Thomas <nhomas@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] Recent driver versions break compatibility with AR9285
 for me
In-Reply-To: <CAEk6VBHTWn8CX7SKNVQz+T+Wqwe9Na=32Lz=+xOdqncNZFhhkQ@mail.gmail.com>
References: <CAEk6VBHnWn_KF0TJ_vojuOhWFhR6TncAok+B9mqgGzAdC5DzVg@mail.gmail.com>
	<20790.56369.998911.884240@gargle.gargle.HOWL>
	<CAEk6VBHTWn8CX7SKNVQz+T+Wqwe9Na=32Lz=+xOdqncNZFhhkQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Thomas wrote:
> The latter iwconfig readout is from an old kernel version (3.2.39),
> where the card does indeed work. What I wish to report is that in a
> more recent kernel version (3.7.10), the card doesn't work (iwconfig
> says "no wireless extensions"). It's not a problem for me (I'm happily
> using the old kernel), but I thought it was worth reporting.

Ah, ok.

> Some Googling tells me that a number of people have run into similar
> problems (kernel versions >=3.3 breaking their AR928X cards). Maybe
> you guys have been made aware of this?

That issue was fixed a long time by reverting the problematic commit.
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=011afa1ed8c408d694957d2474d89dc81a60b70c

3.7.x shouldn't be affected by that issue. Can you post the kernel log ?

Sujith

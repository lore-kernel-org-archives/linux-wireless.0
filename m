Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60242 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1FCJ7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 05:59:42 -0400
Received: by qyg14 with SMTP id 14so863037qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 02:59:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110602000946.GA5951@makis>
References: <20110602000946.GA5951@makis>
Date: Fri, 3 Jun 2011 11:59:41 +0200
Message-ID: <BANLkTimbvSP4TxZU6C6vokqZMpW_ASaPCw@mail.gmail.com> (sfid-20110603_115946_119894_9CB51659)
Subject: Re: [PATCH] ath5k: Disable fast channel switching by default
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 2, 2011 at 2:09 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> Disable fast channel change by default on AR2413/AR5413 due to
> some bug reports (it still works for me but it's better to be safe).
> Add a module parameter "fastchanswitch" in case anyone wants to enable
> it and play with it.
>
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>

Already tested your initial patch from [1] against linux-next (next-20110601).

Feel free to add...

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

[1] http://www.kernel.org/pub/linux/kernel/people/mickflemm/01-fast-chan-switch-modparm

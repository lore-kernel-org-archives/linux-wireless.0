Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47286 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1K1NfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 08:35:05 -0500
Received: by yenl6 with SMTP id l6so2853285yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 05:35:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+icZUUwLuGa87-B1F7Vd=oEM6KLYAd1GnKig84GTfKQx+iU5Q@mail.gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
	<CA+icZUUwLuGa87-B1F7Vd=oEM6KLYAd1GnKig84GTfKQx+iU5Q@mail.gmail.com>
Date: Mon, 28 Nov 2011 15:35:04 +0200
Message-ID: <CAFtRNNzkWcktyCb2Rf-F8Jb8yxSjt=kkmv6vyj5=TabpzC85jQ@mail.gmail.com> (sfid-20111128_143526_167677_3156FE86)
Subject: Re: [PATCH v2 00/12] ath5k: A few updates + cleanups + kerneldoc
From: Nick Kossifidis <mickflemm@gmail.com>
To: sedat.dilek@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/27 Sedat Dilek <sedat.dilek@googlemail.com>:
>
> Unfortunately, <patchwork.kernel.org> is still down, thus I have
> extracted your patchset from your emails.
> I have git-am-ed them in my local linux-next (next-20111125) GIT.
> ( Patchset attached ).
>
> I have only seen this little typo by having a quick view on the single patch:
>
> [ drivers/net/wireless/ath/ath5k/pcu.c ]
>
> + * -Different operating modes: AP, STA, IBSS <--- Space before "Different"
>

I reviewed this and it looks better in html and text output +
checkpatch said it was O.K.

> Any special thing you want to be tested?

AP mode maybe but I think they are fine

> How can I easily generate the (kernel) docs for ath5k (I mean I don't
> want to generate a complete kernel-doc)?

Use the kernel-doc script (inside scripts/) per-file or for the whole directory

> - Sedat -
>
> [1] https://patchwork.kernel.org/project/linux-wireless/list/
>



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick

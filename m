Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9045 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdAWLIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 06:08:53 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 0/8] ath10k sdio support
Date: Mon, 23 Jan 2017 11:08:43 +0000
Message-ID: <87y3y2824l.fsf@kamboji.qca.qualcomm.com> (sfid-20170123_120857_372419_4AD95DAA)
References: <1484342771-6160-1-git-send-email-erik.stromdahl@gmail.com>
In-Reply-To: <1484342771-6160-1-git-send-email-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Fri, 13 Jan 2017 22:26:03 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> This is the third version of the sdio RFC patch series.
> The actual sdio code (patch 6) has been subject to a massive overhaul,
> mainly as a result of Kalle's review comments.
> It no longer has any strong resemblance of the original ath6kl code from
> which it was originally based upon.
>
> Previous pathes 6 to 10 have been merged into one single patch.
>
> The previous series had a rework of the "HTC fake service" connect
> (ep 0 connect) that introduced a race between the actual endpoint
> connect and the HTC ready message. This issue has been addressed,
> and the current patches (3 and 4) has been rewritten accordingly.
>
> * overview of patches *
>
> Patches 1 to 4 are more or less identical to the previous RFC, with an
> exception for patch 3 that changes the "HTC fake service" connect
> (mentioned above).
>
> Patch 5 is a squashed version of previous patches 6 to 10.
>
> Patch 6 is the actual sdio patch
>
> Patches 7 to 8 are new and adds special sdio versions of BMI get
> target info and HTC ready.
>
> The new version was built and tested against:
> tag: ath-201701121109
>
> Erik Stromdahl (8):
>   ath10k: htc: made static function public
>   ath10k: htc: rx trailer lookahead support
>   ath10k: htc: move htc ctrl ep connect to htc_init
>   ath10k: htc: refactorization
>   ath10k: various sdio related definitions
>   ath10k: sdio support
>   ath10k: sdio get target info
>   ath10k: htc: ready_ext msg support

I pushed now this, and your usb series as well, to ath.git
master-pending branch. Let's see if kbuild bot finds any problems.

--=20
Kalle Valo=

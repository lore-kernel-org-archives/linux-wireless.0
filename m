Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17160 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754281AbcINM3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 08:29:11 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Benjamin Berg <benjamin@sipsolutions.net>
CC: Simon Wunderlich <sw@simonwunderlich.de>,
        "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "ath10k @ lists . infradead . org" <ath10k@lists.infradead.org>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Subject: Re: [PATCH] ath10k: Add missing CONFIG_ATH10K_DEBUGFS check
Date: Wed, 14 Sep 2016 12:29:03 +0000
Message-ID: <87a8fafywg.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_142915_223954_F367BEC5)
References: <871t0tp1ad.fsf@kamboji.qca.qualcomm.com>
        <20160912141105.24085-1-benjamin@sipsolutions.net>
In-Reply-To: <20160912141105.24085-1-benjamin@sipsolutions.net> (Benjamin
        Berg's message of "Mon, 12 Sep 2016 16:11:05 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Berg <benjamin@sipsolutions.net> writes:

> The patch "ath10k: allow setting coverage class" was missing a check for
> CONFIG_ATH10K_DEBUGFS so it would try to use non-existing struct elements
> in some configurations. Fix this by adding the appropriate ifdef.
>
> Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
> ---
>
> Sorry, so turns out the kbuild test robot is correct and I forgot the ifd=
ef
> to check for CONFIG_ATH10K_DEBUGFS, so here a fixup commit for it.
>
> Other than that everything looks good to me in the pending branch.

Thanks, I folded this to the original patch in the pending branch.

--=20
Kalle Valo=

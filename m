Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55501 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933723AbcILPbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 11:31:44 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix rfc1042 header retrieval in QCA4019 with eth
 decap mode
Date: Mon, 12 Sep 2016 15:31:35 +0000
Message-ID: <87fup5m8x5.fsf@kamboji.qca.qualcomm.com> (sfid-20160912_174235_251096_229D98E5)
References: <1469623085-13942-1-git-send-email-vthiagar@qti.qualcomm.com>
In-Reply-To: <1469623085-13942-1-git-send-email-vthiagar@qti.qualcomm.com>
        (Vasanthakumar Thiagarajan's message of "Wed, 27 Jul 2016 18:08:05      +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> Chipset from QCA99X0 onwards (QCA99X0, QCA9984, QCA4019 & future)
> rx_hdr_status is not padded to align in 4-byte boundary. Define a
> new hw_params field to handle different alignment behaviour between
> different hw. This patch fixes improper retrieval of rfc1042 header
> with QCA4019. This patch along with "ath10k: Properly remove padding
> from the start of rx payload" will fix traffic failure in ethernet
> decap mode for QCA4019.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

There were some conflicts, I fixed them in the pending branch. Please
check my changes:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=3Dpend=
ing&id=3Dd0d9e40216e1a8edd2f3b387b96aad62c3a49add

--=20
Kalle Valo=

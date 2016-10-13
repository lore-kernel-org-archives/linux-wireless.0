Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7537 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932426AbcJMOJe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 10:09:34 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Cleanup calling ath10k_htt_rx_h_unchain
Date: Thu, 13 Oct 2016 14:06:09 +0000
Message-ID: <877f9ccpim.fsf@kamboji.qca.qualcomm.com> (sfid-20161013_160938_706561_77E2EBAD)
References: <1475596199-4563-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1475596199-4563-1-git-send-email-mohammed@qca.qualcomm.com>
        (Mohammed Shafi Shajakhan's message of "Tue, 4 Oct 2016 21:19:59        +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> 'ath10k_htt_rx_h_unchain' needs to be called only if the return
> value from 'ath10k_htt_rx_amsdu_pop' is 1('chained msdu's'), this
> change makes it more explicit and avoids doing a skb_peek, fetching
> rx descriptor pointer, checking rx msdu decap format for the case of
> ret =3D 0 (unchained msdus). Found this change during code walk through,
> not sure if this addresses any issue.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Applied to ath-next, thanks.

(The SMTP server failed, needed to send this manually)

--=20
Kalle Valo=

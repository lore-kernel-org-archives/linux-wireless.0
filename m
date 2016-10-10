Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57099 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbcJJQAd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 12:00:33 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: cache calibration data when the core is
 stopped
Date: Mon, 10 Oct 2016 15:59:44 +0000
Message-ID: <871szojits.fsf@kamboji.qca.qualcomm.com> (sfid-20161010_180037_655653_CCFD80E6)
References: <1475699037-136212-1-git-send-email-mfaltesek@google.com>
        <8760p0jlv4.fsf@kamboji.qca.qualcomm.com>
        <CAOiWkA8yX6bnLWHTwMc21EJHh4tQHpdBH+yKL4Y9WWxufBKaKQ@mail.gmail.com>
In-Reply-To: <CAOiWkA8yX6bnLWHTwMc21EJHh4tQHpdBH+yKL4Y9WWxufBKaKQ@mail.gmail.com>       (Marty
 Faltesek's message of "Mon, 10 Oct 2016 11:01:05 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> ath10k: cache calibration data when the core is stopped
>
> Caching calibration data allows it to be accessed when the
> device is not active.
>
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>

Thanks, I'll now send v3.

--=20
Kalle Valo=

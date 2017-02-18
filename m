Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22890 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdBRX5i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Feb 2017 18:57:38 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 0/8] ath10k sdio support
Date: Sat, 18 Feb 2017 23:57:10 +0000
Message-ID: <877f4ngii5.fsf@kamboji.qca.qualcomm.com> (sfid-20170219_005741_725208_BB1C7FF3)
References: <1484342771-6160-1-git-send-email-erik.stromdahl@gmail.com>
        <87fujbhb29.fsf@kamboji.qca.qualcomm.com>
        <1c87e0d1-1f14-08bb-2a69-650788fba8dc@gmail.com>
In-Reply-To: <1c87e0d1-1f14-08bb-2a69-650788fba8dc@gmail.com> (Erik
        Stromdahl's message of "Sat, 18 Feb 2017 23:05:03 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> I was actually about to email you about this.
>
> I have made a few more updates to the sdio code so I think it would be
> best if I could submit a new series of patches based on this code (v4).
>
> Then you can tweak it (v5).
>
> It is only minor updates to the HIF layer (added QCA9377 support) and
> a setup of some pll registers.

Ok, that sounds good. I'll wait for v4.

> btw, should I still mark them as RFC or should it be PATCH this time?
>
> If I go for PATCH, should the version be v4 or should I start from v1?

v4 would be fine. Thanks.

--=20
Kalle Valo=

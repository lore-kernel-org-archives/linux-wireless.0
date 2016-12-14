Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33174 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755875AbcLNNrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 08:47:13 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 05/11] ath10k: htc: refactorization
Date: Wed, 14 Dec 2016 13:46:38 +0000
Message-ID: <871sxay66a.fsf@kamboji.qca.qualcomm.com> (sfid-20161214_144722_163331_B172F28C)
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
        <1479496971-19174-6-git-send-email-erik.stromdahl@gmail.com>
        <87inqoymd0.fsf@kamboji.qca.qualcomm.com>
        <CA+BoTQkuUFxnra75B4LpF5+k9yE7hkNYDXbtUMBLq2LFuPSasg@mail.gmail.com>
        <871sxbzqo6.fsf@kamboji.qca.qualcomm.com>
        <70b8a055-e6ba-857d-8b03-06f50e3f10fe@gmail.com>
In-Reply-To: <70b8a055-e6ba-857d-8b03-06f50e3f10fe@gmail.com> (Erik
        Stromdahl's message of "Tue, 13 Dec 2016 19:37:30 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> I have made a few updates since I submitted the original RFC and created
> a repo on github:
>
> https://github.com/erstrom/linux-ath
>
> I have a bunch of branches that are all based on the tags on the ath mast=
er.
>
> As of this moment the latest version is:
>
> ath-201612131156-ath10k-sdio
>
> This branch contains the original RFC patches plus some addons/fixes.

Good, this makes it easier to follow the development. So what's the
current status with this branch? What works and what doesn't?

Especially I'm interested about the state of the HTT high latency
support. How much work is to add that? It would also make it easier to
add USB support to ath10k.

--=20
Kalle Valo=

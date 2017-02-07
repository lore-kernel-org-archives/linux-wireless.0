Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36068 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbdBGJOp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 04:14:45 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: =?iso-8859-2?Q?Amadeusz_S=B3awi=F1ski?=
        <amadeusz.slawinski@tieto.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: remove ath10k_vif_to_arvif()
Date: Tue, 7 Feb 2017 09:14:42 +0000
Message-ID: <87y3xi4b28.fsf@qca.qualcomm.com> (sfid-20170207_101513_931839_4090A1A0)
References: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
        <CAJ-VmonrHpS3MArM9ohHgLvb6xspP_gnVVeJWA9F-pjUpJ+LZA@mail.gmail.com>
In-Reply-To: <CAJ-VmonrHpS3MArM9ohHgLvb6xspP_gnVVeJWA9F-pjUpJ+LZA@mail.gmail.com>       (Adrian
 Chadd's message of "Thu, 2 Feb 2017 08:17:00 -0800")
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> Removing this method makes the diff to FreeBSD larger, as "vif" in
> FreeBSD is a different pointer.
>
> (Yes, I have ath10k on freebsd working and I'd like to find a way to
> reduce the diff moving forward.)

I don't like this "(void *) vif->drv_priv" style that much either but
apparently it's commonly used in Linux wireless code and already parts
of ath10k. So this patch just unifies the coding style.

--=20
Kalle Valo=

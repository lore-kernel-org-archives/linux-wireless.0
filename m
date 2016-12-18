Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12163 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbcLRT5v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Dec 2016 14:57:51 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Gabriel C <nix.or.die@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: regression: ath_tx_edma_tasklet() Illegal idle entry in RCU
 read-side critical section
Date: Sun, 18 Dec 2016 19:57:42 +0000
Message-ID: <87pokpc8ng.fsf@qca.qualcomm.com> (sfid-20161218_205903_749562_FA94F2E7)
References: <23a2a3ab-974a-ed26-6afa-aafab9bb972e@gmail.com>
        <20161218155938.GP3924@linux.vnet.ibm.com>
        <58b67d5b-0275-f80f-479f-78cf748b4319@mni.thm.de>
In-Reply-To: <58b67d5b-0275-f80f-479f-78cf748b4319@mni.thm.de> (Tobias
        Klausmann's message of "Sun, 18 Dec 2016 17:17:54 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de> writes:

> A patch for this is already floating on the ML for a while now latest:
> (ath9k: do not return early to fix rcu unlocking)

It's here:

https://patchwork.kernel.org/patch/9472709/

> Hopefully Kalle will include it in one of his upcoming pull requests.

Yes, I'll try to get it to 4.10-rc2.

--=20
Kalle Valo=

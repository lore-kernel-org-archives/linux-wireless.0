Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.fh-giessen.de ([212.201.18.42]:48668 "EHLO
        mout1.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbcLRUEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Dec 2016 15:04:11 -0500
Subject: Re: regression: ath_tx_edma_tasklet() Illegal idle entry in RCU
 read-side critical section
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Gabriel C <nix.or.die@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>
References: <23a2a3ab-974a-ed26-6afa-aafab9bb972e@gmail.com>
 <20161218155938.GP3924@linux.vnet.ibm.com>
 <58b67d5b-0275-f80f-479f-78cf748b4319@mni.thm.de>
 <87pokpc8ng.fsf@qca.qualcomm.com>
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Message-ID: <aa88f071-edb7-7690-e0e5-b3e2c93e6539@mni.thm.de> (sfid-20161218_210516_678210_AE0E9755)
Date: Sun, 18 Dec 2016 21:04:07 +0100
MIME-Version: 1.0
In-Reply-To: <87pokpc8ng.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 18.12.2016 20:57, Valo, Kalle wrote:
> Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de> writes:
>
>> A patch for this is already floating on the ML for a while now latest:
>> (ath9k: do not return early to fix rcu unlocking)
> It's here:
>
> https://patchwork.kernel.org/patch/9472709/

Good to know!
>
>> Hopefully Kalle will include it in one of his upcoming pull requests.
> Yes, I'll try to get it to 4.10-rc2.

Thanks for the update!

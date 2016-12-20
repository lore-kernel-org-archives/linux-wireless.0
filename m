Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22639 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935235AbcLTOUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 09:20:45 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Gabriel C <nix.or.die@gmail.com>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Tobias Klausmann" <tobias.johannes.klausmann@mni.thm.de>,
        lkml <linux-kernel@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: regression: ath_tx_edma_tasklet() Illegal idle entry in RCU
 read-side critical section
Date: Tue, 20 Dec 2016 14:20:38 +0000
Message-ID: <87oa06u1fu.fsf@kamboji.qca.qualcomm.com> (sfid-20161220_152118_697125_21961DF8)
References: <23a2a3ab-974a-ed26-6afa-aafab9bb972e@gmail.com>
        <20161218155938.GP3924@linux.vnet.ibm.com>
        <58b67d5b-0275-f80f-479f-78cf748b4319@mni.thm.de>
        <87pokpc8ng.fsf@qca.qualcomm.com>       <20161218201410.GS3924@linux.vnet.ibm.com>
        <20b64afc-8270-27d5-6d45-592ce6dd24c7@gmail.com>
In-Reply-To: <20b64afc-8270-27d5-6d45-592ce6dd24c7@gmail.com> (Gabriel C.'s
        message of "Mon, 19 Dec 2016 00:11:32 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabriel C <nix.or.die@gmail.com> writes:

> On 18.12.2016 21:14, Paul E. McKenney wrote:
>> On Sun, Dec 18, 2016 at 07:57:42PM +0000, Valo, Kalle wrote:
>>> Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de> writes:
>>>
>>>> A patch for this is already floating on the ML for a while now latest:
>>>> (ath9k: do not return early to fix rcu unlocking)
>>>
>>> It's here:
>>>
>>> https://patchwork.kernel.org/patch/9472709/
>>
>> Feel free to add:
>>
>> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
>
> This patch fixes the bug for me.
>
> You can add my Tested-by if you wish.
>
> Tested-by: Gabriel Craciunescu <nix.or.die@gmail.com>

I added both of these to the commit log, thanks.

--=20
Kalle Valo=

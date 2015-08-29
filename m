Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:48557 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbbH2Ks7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2015 06:48:59 -0400
Message-ID: <55E18E18.8040608@broadcom.com> (sfid-20150829_124907_004724_91107C8C)
Date: Sat, 29 Aug 2015 12:48:56 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH V2 3/7] brcmfmac: Increase nr of supported flowrings.
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>	<1439708139-7527-4-git-send-email-arend@broadcom.com>	<CACna6ryL04p-cHptZnvYZ9fvnGn3FafN9PPNxsMPPfmdkSEjnA@mail.gmail.com>	<55DB26FC.1060707@broadcom.com>	<CACna6ry3_4u_xAmeU8Hsoc96ZeVKFSq9zHL-yTFDT1hrgJa_BA@mail.gmail.com>	<55E169AB.3080309@broadcom.com> <CACna6rz88F6daCGtm5TgJ2hqb4FrnUX5-fqvNneePPdVb=q00w@mail.gmail.com>
In-Reply-To: <CACna6rz88F6daCGtm5TgJ2hqb4FrnUX5-fqvNneePPdVb=q00w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2015 11:38 AM, Rafał Miłecki wrote:
> On 29 August 2015 at 10:13, Arend van Spriel <arend@broadcom.com> wrote:
>> First about the warnings in core.c:1144. I believe they are fixed by one of
>> the patches submitted last week [1].
>
> This is correct :)
>
>
>> Now about the problem upon start_xmit. The theory was that you had
>> allocation failure leading to the null pointer deref. If you don't see any
>> allocation failure on your setup that theory seems invalid. So there is
>> another root cause that we need to find.
>
> Let me know if you have any patches (fixing or debugging) you want me
> to test. I'll be happy to help.

So can you indicate whether you have seen allocation failures or not.

Regards,
Arend

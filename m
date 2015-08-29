Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35483 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbbH2Jih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2015 05:38:37 -0400
Received: by igph8 with SMTP id h8so27412419igp.0
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2015 02:38:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55E169AB.3080309@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
	<1439708139-7527-4-git-send-email-arend@broadcom.com>
	<CACna6ryL04p-cHptZnvYZ9fvnGn3FafN9PPNxsMPPfmdkSEjnA@mail.gmail.com>
	<55DB26FC.1060707@broadcom.com>
	<CACna6ry3_4u_xAmeU8Hsoc96ZeVKFSq9zHL-yTFDT1hrgJa_BA@mail.gmail.com>
	<55E169AB.3080309@broadcom.com>
Date: Sat, 29 Aug 2015 11:38:36 +0200
Message-ID: <CACna6rz88F6daCGtm5TgJ2hqb4FrnUX5-fqvNneePPdVb=q00w@mail.gmail.com> (sfid-20150829_113840_623681_1BD997B4)
Subject: Re: [PATCH V2 3/7] brcmfmac: Increase nr of supported flowrings.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 August 2015 at 10:13, Arend van Spriel <arend@broadcom.com> wrote:
> First about the warnings in core.c:1144. I believe they are fixed by one of
> the patches submitted last week [1].

This is correct :)


> Now about the problem upon start_xmit. The theory was that you had
> allocation failure leading to the null pointer deref. If you don't see any
> allocation failure on your setup that theory seems invalid. So there is
> another root cause that we need to find.

Let me know if you have any patches (fixing or debugging) you want me
to test. I'll be happy to help.

-- 
Rafał

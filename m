Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47506 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1EJCVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 22:21:20 -0400
Received: by yia27 with SMTP id 27so2013447yia.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 19:21:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC83B03.5070002@candelatech.com>
References: <4DBF1967.9010604@candelatech.com>
	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
	<4DC042A5.9050806@candelatech.com>
	<BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com>
	<4DC17DAE.9020808@candelatech.com>
	<4DC47C04.1080604@candelatech.com>
	<4DC83B03.5070002@candelatech.com>
Date: Tue, 10 May 2011 10:21:19 +0800
Message-ID: <BANLkTimtRz8SMTRnn57CUgkudJ6=_vK+kw@mail.gmail.com> (sfid-20110510_042134_640857_A92B388F)
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2011 03:05, Ben Greear <greearb@candelatech.com> wrote:

> The NIC is still showing up funky on the other system (Atom), even with the
> same 39-rc6+ kernel.
>
> This NIC is reliably showing up wrong on in this system, and the other
> is reliably showing up well, so I think the problem must be with
> the NIC or perhaps the ath9k driver.
>
When you say "other NIC", you mean "BC1A" revision, rather than "AC1E" ?

> If anyone has any suggestions for how to debug this further, I'm
> interested...

Can you try (much) earlier kernels? Ignore ath9k; ath9k shouldn't be
needed for the card device id to be setup on PCI bus reset or whenever
specifically it happens.


Adrian

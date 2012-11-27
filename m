Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48502 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2K0RJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 12:09:51 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so4029370wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 09:09:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d_+Pp_p2uWW52Q4q_D3enkgUtrJrUNivjf6wqvh8RYfKA@mail.gmail.com>
References: <1354031236-8191-1-git-send-email-helmut.schaa@googlemail.com>
	<CAOZOX0XN+pd7k-WQ0U1Vs=+21wyUmEDMJVJHekAj2NvmZfaJTg@mail.gmail.com>
	<CAGXE3d_+Pp_p2uWW52Q4q_D3enkgUtrJrUNivjf6wqvh8RYfKA@mail.gmail.com>
Date: Tue, 27 Nov 2012 18:09:49 +0100
Message-ID: <CAGXE3d-1Bf7weo1ocuLOJ5HvMJQcEKLU0Z2bojdbPeN+WESing@mail.gmail.com> (sfid-20121127_180954_257815_3C08A7E5)
Subject: Re: [PATCH] rt2x00: Use addr_mask to catch invalid MAC addresses
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 6:00 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
>> Shouldn't this be added for rt61pci and rt73usb as well?
>
> I'm not 100% sure if the same is true in rt61pci and rt73usb. Are they
> also using an
> address mask?

Hmm, I think Ivo is right. We should add the same for rt61pci and rt73usb
but they only support the last two bits to be used. Hence an address mask
of 0x3.

I'll send a follow-up.

Helmut

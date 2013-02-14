Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:63942 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3BNJOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 04:14:49 -0500
Received: by mail-we0-f169.google.com with SMTP id t11so1775654wey.14
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 01:14:48 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAMXmbB=xuBErzdLdePGG1JBD3M++6wXkPcGsRKWXGDGqdKFrBw@mail.gmail.com>
References: <CAMXmbB=xuBErzdLdePGG1JBD3M++6wXkPcGsRKWXGDGqdKFrBw@mail.gmail.com>
Date: Thu, 14 Feb 2013 10:14:48 +0100
Message-ID: <CA+icZUWoZX1a0_kqR_Bz94TkzOw2GjmcvPGjjNNkhebPkCOP3A@mail.gmail.com> (sfid-20130214_101454_074005_65211AEB)
Subject: Re: WPA2 encryption doesn't work with Intel AGN 5300 in kernel 3.8
From: Sedat Dilek <sedat.dilek@gmail.com>
To: scalpel4k <scalpel4k@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 14, 2013 at 10:10 AM, scalpel4k <scalpel4k@gmail.com> wrote:
> Attached is the kernel log when I was trying to connect to a WPA2
> secure WLAN. This is only one of the kernels I have tried, a plain
> vanilla rc7 still has the same issue.
> Connecting to an unsecured WLAN does work. For the WPA2 WLAN I have to
> switch back to a 3.7 kernel where everything is working properly.
>
> I hope this was enough information
>

The subject line is this time a bit more meaningful :-).
More informations like your kernel-config and/or lspci/lsusb might be helpful.
Check the docs section on <wireless.kernel.org> on how to debug iwlwifi.

- Sedat -

> bye Michi

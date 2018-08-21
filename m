Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42800 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726115AbeHUJsk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:48:40 -0400
Message-ID: <d2aafbe259d10d849aa0710530b328f9eae4ecf2.camel@coelho.fi> (sfid-20180821_083007_911869_6BDE94DD)
From: Luca Coelho <luca@coelho.fi>
To: "R. Alejandro Oquendo" =?ISO-8859-1?Q?Mu=F1oz?=
        <rd.qnd.m@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 09:29:50 +0300
In-Reply-To: <CABCw=ciXSrxNumPtk_W+aso9eDbhjennsKT6VFq2va=hej7jKA@mail.gmail.com>
References: <CABCw=ciXSrxNumPtk_W+aso9eDbhjennsKT6VFq2va=hej7jKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Support for Killer/Wireless-AC 9260 wireless cards
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, 2018-07-29 at 22:59 -0400, R. Alejandro Oquendo Muñoz wrote:
> Hi,
> Are there any plans to officially support "Killer/Wireless-AC 9260
> wireless cards" in Linux 4.19?
> For now this card works using this patch [1] in Manjaro, and also
> works for Archlinux distro [2].
> 
> Thanks,
> Alejandro
> 
> [1] "Subject: [PATCH] iwlwifi: add killer cards for 9000 series"
> 
https://gitlab.manjaro.org/packages/core/linux418/blob/master/0001-iwlwifi-killer-ac-1550.patch
> [2] https://bugs.archlinux.org/task/59202

The PCI IDs for the Killer cards were sent upstream and are part of
4.18 already, as well as some stable versions.  The commit is this:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0a5257bc6d89c2ae69b9bf955679cb4f89261874

Please let us know if you still have issues with it.

--
Cheers,
Luca.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751927AbdDAWCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 18:02:45 -0400
Date: Sun, 2 Apr 2017 00:02:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] nfc: nxp-nci: Remove unneeded linux/miscdevice.h
 include
Message-ID: <20170401220234.GC22034@zurbaran.ger.intel.com> (sfid-20170402_000345_993648_382B0BE6)
References: <20161215142246.6153-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161215142246.6153-1-clabbe.montjoie@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Corentin,

On Thu, Dec 15, 2016 at 03:22:44PM +0100, Corentin Labbe wrote:
> drivers/nfc/nxp-nci/i2c.c does not use any miscdevice, so this patch
> remove this unnecessary inclusion.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/nfc/nxp-nci/i2c.c | 1 -
>  1 file changed, 1 deletion(-)
All 3 patches applied, thanks.

Cheers,
Samuel.

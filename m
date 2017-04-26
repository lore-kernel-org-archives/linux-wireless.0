Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56238 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754440AbdDZWJL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 18:09:11 -0400
Date: Thu, 27 Apr 2017 00:09:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 0/9] NFC: trf7970a: Fixups & convert to desc-based GPIO
Message-ID: <20170426220900.GA3717@zurbaran.ger.intel.com> (sfid-20170427_000915_917529_6D445226)
References: <20170425224356.11498-1-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170425224356.11498-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Tue, Apr 25, 2017 at 03:43:47PM -0700, Mark Greer wrote:
> These trf7970a driver patches do the following things:
>  - add Mark Greer as the maintainer of the trf7970a driver
>  - some minor fixups
>  - remove support for 'vin-voltage-override' DT property
>  - change the DTS example to indicate that EN and EN2 are active high GPIOs
>  - convert the driver to use the descriptor-based GPIO interface
>  - apply Lindent coding style fixes
> 
> Based on nfc-next/master 4ea206395d3a ("nfc: fix get_unaligned_...() misuses")
> 
> v4->v5:
>  - Fixed whitespace issue in "NFC: trf7970a: Clean up coding style issues"
> 
> v3->v4:
>  - Rebased on nfc-next/master because patches in that branch conflict
>    with the v3 version of this patch series.
>  - Removed "NFC: trf7970a: Don't manage EN2 when not specified in DT"
>    because a similar patch has already been accepted.
>  - Added "NFC: trf7970a: Clean up coding style issues" because the reason
>    I removed it in v3 no longer exists.
>  - Reordered the patches to make more sense (I think)
> 
> v2->v3:
>  - Removed "[PATCH v2 5/7] NFC: trf7970a: Clean up coding style issues"
>    because it will make merging patches from Geoff Lansberry and others
>    hard to apply.  I will resubmit once those patches have been merged
>    or rejected.
>  - Added a patch to remove 'vin-voltage-override' DT property support as
>    proper DT regulator set up makes it unnecessary.
> 
> v1->v2:
>  - Commit description fixups only; no functional changes.
> 
> Mark Greer (9):
>   MAINTAINERS: NFC: trf7970a: Add Mark Greer as maintainer
>   NFC: trf7970a: Don't de-assert EN2 unless it was asserted
>   NFC: trf7970a: Fix inaccurate comment in trf7970a_probe()
>   NFC: trf7970a: Only check 'en2-rf-quirk' if EN2 is specified
>   NFC: trf7970a: Remove useless comment
>   NFC: trf7970a: Remove support for 'vin-voltage-override' DT property
>   NFC: trf7970a: Enable pins are active high not active low
>   NFC: trf7970a: Convert to descriptor based GPIO interface
>   NFC: trf7970a: Clean up coding style issues
All patches applied to nfc-next, thanks.

Cheers,
Samuel.

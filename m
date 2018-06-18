Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:2584 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933099AbeFRHy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 03:54:26 -0400
Date: Mon, 18 Jun 2018 09:54:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: linux-wireless@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] NFC: fdp: Fix unused variable warnings
Message-ID: <20180618075419.GD5251@caravaggio> (sfid-20180618_095429_948325_21AAA45D)
References: <1528812850-16158-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1528812850-16158-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Tue, Jun 12, 2018 at 07:44:10PM +0530, Amit Pundir wrote:
> Fix unused variable warnings reported on next-20180612.
> 
> Fixes: 7579d009c4a1 ("NFC: fdp: Remove __func__ from dev_dbg()")
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
>  drivers/nfc/fdp/fdp.c | 13 -------------
>  1 file changed, 13 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.

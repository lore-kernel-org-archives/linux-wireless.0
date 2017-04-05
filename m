Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:26092 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754592AbdDEIQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:16:12 -0400
Date: Wed, 5 Apr 2017 10:16:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v1] NFC: netlink: Use error code from
 nfc_activate_target()
Message-ID: <20170405081544.GC2136@zurbaran.ger.intel.com> (sfid-20170405_102010_874281_6EBBBFCD)
References: <20170322192058.30193-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170322192058.30193-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Wed, Mar 22, 2017 at 09:20:58PM +0200, Andy Shevchenko wrote:
> It looks like a typo to assign a return code to a variable which is not
> used. Found due to a compiler warning:
> 
> net/nfc/netlink.c: In function ‘nfc_genl_activate_target’:
> net/nfc/netlink.c:903:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
>   int rc;
>         ^~
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  net/nfc/netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, thanks.

Cheers,
Samuel.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:8212 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754605AbdDEIQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:16:46 -0400
Date: Wed, 5 Apr 2017 10:16:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v1] NFC: Add nfc_dbg() macro
Message-ID: <20170405081630.GD2136@zurbaran.ger.intel.com> (sfid-20170405_102009_799619_5531BD92)
References: <20170322192251.30261-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170322192251.30261-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 22, 2017 at 09:22:51PM +0200, Andy Shevchenko wrote:
> In some cases nfc_dbg() is useful. Add such macro to a header.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/net/nfc/nfc.h | 1 +
>  1 file changed, 1 insertion(+)
Applied as well.

Cheers,
Samuel.

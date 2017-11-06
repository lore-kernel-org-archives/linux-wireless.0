Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39832 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750904AbdKFAGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 19:06:24 -0500
Date: Mon, 6 Nov 2017 01:06:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Colin King <colin.king@canonical.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: fdp: make struct nci_ops static
Message-ID: <20171106000620.GD27831@zurbaran.ger.intel.com> (sfid-20171106_010638_698853_7472F791)
References: <20171005094712.28627-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171005094712.28627-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 05, 2017 at 10:47:12AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The structure nci_ops is local to the source and does not need to
> be in global scope, so make it static.
> 
> Cleans up sparse warning:
> symbol 'nci_ops' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/nfc/fdp/fdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied as well, thanks.

Cheers,
Samuel.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:61758 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbeFDEQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 00:16:48 -0400
Date: Mon, 4 Jun 2018 06:16:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Colin King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: st21nfca: use setup_timer instead of init_timer
Message-ID: <20180604041647.GA8977@zurbaran.ger.intel.com> (sfid-20180604_061854_919182_CD7B603F)
References: <20171124133741.32371-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171124133741.32371-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

On Fri, Nov 24, 2017 at 01:37:41PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Use setup_timer function instead of initializing timer with the
> function and data fields.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/nfc/st21nfca/se.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.

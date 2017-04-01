Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3168 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751941AbdDAWTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 18:19:18 -0400
Date: Sun, 2 Apr 2017 00:19:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: christophe.ricard@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NFC: st21nfca: Fix potential memory leak
Message-ID: <20170401221914.GE22034@zurbaran.ger.intel.com> (sfid-20170402_001938_035128_EE24B482)
References: <20170219095847.9397-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170219095847.9397-1-christophe.jaillet@wanadoo.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christophe,

On Sun, Feb 19, 2017 at 10:58:47AM +0100, Christophe JAILLET wrote:
> If all bits of 'dev_mask' are already set, there is a memory leak because
> 'info' should be freed before returning.
> 
> While fixing it, 'return -ENOMEM' directly if the first kzalloc fails.
> This makes the code more readable.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/nfc/st21nfca/core.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
Applied, thanks.

Cheers,
Samuel.

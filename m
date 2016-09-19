Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16419 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754044AbcISIen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:34:43 -0400
Date: Mon, 19 Sep 2016 10:34:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        kernel-janitors@vger.kernel.org,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: pn533: constify pn533_phy_ops structures
Message-ID: <20160919083439.GA13777@zurbaran.home> (sfid-20160919_103652_711625_BE4FD74A)
References: <1470759062-21276-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470759062-21276-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julia,

On Tue, Aug 09, 2016 at 06:11:02PM +0200, Julia Lawall wrote:
> The pn533_phy_ops are never modified, so declare them as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/nfc/pn533/i2c.c   |    2 +-
>  drivers/nfc/pn533/pn533.c |    2 +-
>  drivers/nfc/pn533/pn533.h |    4 ++--
>  drivers/nfc/pn533/usb.c   |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.

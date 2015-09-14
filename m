Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbbINEqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 00:46:42 -0400
Date: Sun, 13 Sep 2015 21:46:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aparna Karuthodi <kdasaparna@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: Added a new line
Message-ID: <20150914044642.GA2152@kroah.com> (sfid-20150914_064654_845636_1EBD616B)
References: <1442142093-30207-1-git-send-email-kdasaparna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442142093-30207-1-git-send-email-kdasaparna@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 13, 2015 at 04:31:33PM +0530, Aparna Karuthodi wrote:
> Added a new line after declaration to remove a coding style warning
> detected by checkpatch. The warning is given below
> WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index ed6ac45..0c964c6 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -2101,6 +2101,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
>  			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
>  {
>  	s32 counter = 0, ret = 0;
> +
>  	if (gpstrWlanOps == NULL) {
>  		PRINT_D(CORECONFIG_DBG, "Net Dev is still not initialized\n");
>  		return 1;

someone already sent in this change before you did, sorry.

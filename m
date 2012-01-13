Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56646 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933Ab2AMTqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 14:46:07 -0500
Date: Fri, 13 Jan 2012 14:38:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] MAINTAINERS: move BCMA to keep the list sorted
Message-ID: <20120113193833.GF18899@tuxdriver.com> (sfid-20120113_204613_119965_68F399EA)
References: <1326385740-11203-1-git-send-email-zajec5@gmail.com>
 <1326385740-11203-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1326385740-11203-2-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patches need Signed-off-by lines...

On Thu, Jan 12, 2012 at 05:28:59PM +0100, Rafał Miłecki wrote:
> ---
>  MAINTAINERS |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4babed7..dc11e28 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1595,6 +1595,13 @@ L:	linux-scsi@vger.kernel.org
>  S:	Supported
>  F:	drivers/scsi/bnx2fc/
>  
> +BROADCOM SPECIFIC AMBA DRIVER (BCMA)
> +M:	Rafał Miłecki <zajec5@gmail.com>
> +L:	linux-wireless@vger.kernel.org
> +S:	Maintained
> +F:	drivers/bcma/
> +F:	include/linux/bcma/
> +
>  BROCADE BFA FC SCSI DRIVER
>  M:	Jing Huang <huangj@brocade.com>
>  L:	linux-scsi@vger.kernel.org
> @@ -6101,13 +6108,6 @@ S:	Maintained
>  F:	drivers/ssb/
>  F:	include/linux/ssb/
>  
> -BROADCOM SPECIFIC AMBA DRIVER (BCMA)
> -M:	Rafał Miłecki <zajec5@gmail.com>
> -L:	linux-wireless@vger.kernel.org
> -S:	Maintained
> -F:	drivers/bcma/
> -F:	include/linux/bcma/
> -
>  SONY VAIO CONTROL DEVICE DRIVER
>  M:	Mattia Dongili <malattia@linux.it>
>  L:	platform-driver-x86@vger.kernel.org
> -- 
> 1.7.7
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

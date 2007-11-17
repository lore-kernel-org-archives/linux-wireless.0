Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4828 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbXKQQ7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2007 11:59:08 -0500
Date: Sat, 17 Nov 2007 11:55:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: [PATCH] libertas: list as orphan in MAINTAINERS
Message-ID: <20071117165551.GA5817@tuxdriver.com> (sfid-20071117_165920_270874_23F9CDAF)
References: <20071117023020.0a164e90@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071117023020.0a164e90@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why is this appropriate?

On Sat, Nov 17, 2007 at 02:30:20AM +0100, Stefano Brivio wrote:
> List the Marvell Libertas wireless driver as orphan in the MAINTAINERS
> file.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ---
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 18b7c8e..76bfb9a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2513,6 +2513,9 @@ M:	mtk.manpages@gmail.com
>  W:	ftp://ftp.kernel.org/pub/linux/docs/manpages
>  S:	Maintained
>  
> +MARVELL LIBERTAS WIRELESS DRIVER
> +S:	Orphan
> +
>  MARVELL MV643XX ETHERNET DRIVER
>  P:	Dale Farnsworth
>  M:	dale@farnsworth.org
> 
> 
> -- 
> Ciao
> Stefano

-- 
John W. Linville
linville@tuxdriver.com

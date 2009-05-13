Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms13-1.sony.co.jp ([211.125.136.229]:49134 "EHLO
	ms13.sony.co.jp" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755991AbZEMASg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 20:18:36 -0400
Message-Id: <200905130012.n4D0CSWP014563@imail.sm.sony.co.jp>
Date: Wed, 13 May 2009 09:12:46 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch] net/ps3: Update maintainer
Cc: jgarzik@pobox.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A09F8C2.5040708@am.sony.com>
References: <49F77C32.8020207@am.sony.com> <4A09F8C2.5040708@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 12 May 2009 15:31:30 -0700
Geoff Levand <geoffrey.levand@am.sony.com> wrote:

> Subject: net/ps3: Update maintainer
> 
> From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> 
> Update the MAINTAINERS entry for PS3 NETWORK SUPPORT.
> 
> CC: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>

Acked-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>

> ---
> 
> Hi Jeff,
> 
> This is another resend of my patch from March 30th.
> 
> I would like to get this in for 2.6.30 so bug reports,
> etc. will get routed to the right person.
> 
> Please apply. Thanks.
> 
>  MAINTAINERS |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4421,8 +4421,8 @@ S:	Maintained
>  F:	drivers/ata/sata_promise.*
>  
>  PS3 NETWORK SUPPORT
> -P:	Masakazu Mokuno
> -M:	mokuno@sm.sony.co.jp
> +P:	Geoff Levand
> +M:	geoffrey.levand@am.sony.com
>  L:	netdev@vger.kernel.org
>  L:	cbe-oss-dev@ozlabs.org
>  S:	Supported

-- 
Masakazu Mokuno


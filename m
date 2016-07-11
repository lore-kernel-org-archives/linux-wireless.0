Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46338
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbcGKXRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 19:17:53 -0400
Message-ID: <5784291B.9010002@osg.samsung.com> (sfid-20160712_011757_141849_E6C16726)
Date: Tue, 12 Jul 2016 00:17:47 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: akpm@linux-foundation.org, David Miller <davem@davemloft.net>,
	mm-commits@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	nicolas.ferre@atmel.com
Subject: Re: + maintainers-remove-unreachable-people-that-have-left-atmel.patch
 added to -mm tree
References: <578424eb.gTszFlACY5dPKGsR%akpm@linux-foundation.org>
In-Reply-To: <578424eb.gTszFlACY5dPKGsR%akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/16 23:59, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: MAINTAINERS: remove unreachable people that have left Atmel
> has been added to the -mm tree.  Its filename is
>      maintainers-remove-unreachable-people-that-have-left-atmel.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-unreachable-people-that-have-left-atmel.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-unreachable-people-that-have-left-atmel.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Luis de Bethencourt <luisbg@osg.samsung.com>
> Subject: MAINTAINERS: remove unreachable people that have left Atmel
> 
> When sending an email regarding a patch to wilc1000, you get the following
> automatic replies:
> "Sung_hoon Cho is no longer with Atmel Corporation."
> "Kang_hee Park is no longer with Atmel Corporation."
> "Dong_ho Shin is no longer with Atmel Corporation."
> "Bo_moon Kim is no longer with Atmel Corporation."
> "Min_su Kim is no longer with Atmel Corporation."
> "Jun_hyuk Lee is no longer with Atmel Corporation."
> 
> Removing this entry since none of the maintainers are reachable.
> 
> Link: http://lkml.kernel.org/r/1467033373-20967-1-git-send-email-luisbg@osg.samsung.com
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> Cc: Greg KH <greg@kroah.com>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  MAINTAINERS |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff -puN MAINTAINERS~maintainers-remove-unreachable-people-that-have-left-atmel MAINTAINERS
> --- a/MAINTAINERS~maintainers-remove-unreachable-people-that-have-left-atmel
> +++ a/MAINTAINERS
> @@ -11131,17 +11131,6 @@ M:	Forest Bond <forest@alittletooquiet.n
>  S:	Odd Fixes
>  F:	drivers/staging/vt665?/
>  
> -STAGING - WILC1000 WIFI DRIVER
> -M:	Johnny Kim <johnny.kim@atmel.com>
> -M:	Austin Shin <austin.shin@atmel.com>
> -M:	Chris Park <chris.park@atmel.com>
> -M:	Tony Cho <tony.cho@atmel.com>
> -M:	Glen Lee <glen.lee@atmel.com>
> -M:	Leo Kim <leo.kim@atmel.com>
> -L:	linux-wireless@vger.kernel.org
> -S:	Supported
> -F:	drivers/staging/wilc1000/
> -
>  STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
>  M:	Arnaud Patard <arnaud.patard@rtp-net.org>
>  S:	Odd Fixes
> _
> 
> Patches currently in -mm which might be from luisbg@osg.samsung.com are
> 
> befs-check-return-of-sb_min_blocksize.patch
> befs-fix-function-name-in-documentation.patch
> befs-remove-unused-functions.patch
> maintainers-remove-unreachable-people-that-have-left-atmel.patch
> 

Hi Andrew,

Nicolas Ferre proposed the following people instead in this reply patch:
https://lkml.org/lkml/2016/6/27/382

Sounds better than making the driver orphan. But I am not sure if this has
been approved by Greg or not. Just a heads up since I thought you might want
to know.

Thanks,
Luis

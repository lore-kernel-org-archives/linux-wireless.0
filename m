Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:58211
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561AbXKFM6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 07:58:34 -0500
Message-ID: <47306332.1020507@gentoo.org> (sfid-20071106_125837_230880_50E8CAB9)
Date: Tue, 06 Nov 2007 07:50:58 -0500
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] softmac: MAINTAINERS update
References: <1194269555.4567.4.camel@johannes.berg>
In-Reply-To: <1194269555.4567.4.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This patch marks softmac as obsolete in MAINTAINERS and removes Joe and
> myself as maintainers, we're no longer using it nor interested in the
> code in any way. Also remove the website reference because I took it
> offline. Hopefully the code will go away in 2.6.25.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  MAINTAINERS |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> --- linux-2.6.orig/MAINTAINERS	2007-11-05 14:27:07.323066514 +0100
> +++ linux-2.6/MAINTAINERS	2007-11-05 14:28:14.433057291 +0100
> @@ -3450,15 +3450,10 @@ L:	lm-sensors@lm-sensors.org
>  S:	Maintained
>  
>  SOFTMAC LAYER (IEEE 802.11)
> -P:	Johannes Berg
> -M:	johannes@sipsolutions.net
> -P:	Joe Jezak
> -M:	josejx@gentoo.org
>  P:	Daniel Drake
>  M:	dsd@gentoo.org
> -W:	http://softmac.sipsolutions.net/
>  L:	linux-wireless@vger.kernel.org
> -S:	Maintained
> +S:	Obsolete
>  
>  SOFTWARE RAID (Multiple Disks) SUPPORT
>  P:	Ingo Molnar

Acked-by: Joseph Jezak <josejx@gentoo.org>


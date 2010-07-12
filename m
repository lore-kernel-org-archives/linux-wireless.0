Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:40315 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0GLPWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 11:22:53 -0400
Received: by pxi14 with SMTP id 14so1847388pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 08:22:53 -0700 (PDT)
Message-ID: <4C3B3342.3060801@lwfinger.net>
Date: Mon, 12 Jul 2010 10:22:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Wu <aluminum.tape@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] wireless: mark adm8211 and p54 orphaned
References: <1278947189-14833-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1278947189-14833-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2010 10:06 AM, Luis R. Rodriguez wrote:
> Michael has been out of the scene for a while now, these
> drivers are really orphaned so mark them as such.
>
> Cc: Michael Wu<aluminum.tape@gmail.com>
> Cc: Larry Finger<Larry.Finger@lwfinger.net>
> Cc: Christian Lamparter<chunkeey@googlemail.com>
> Signed-off-by: Luis R. Rodriguez<lrodriguez@atheros.com>
> ---
>   MAINTAINERS |    6 ++----
>   1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a07a49d..6ed6135 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4270,11 +4269,10 @@ F:	include/scsi/osd_*
>   F:	fs/exofs/
>
>   P54 WIRELESS DRIVER
> -M:	Michael Wu<flamingice@sourmilk.net>
>   L:	linux-wireless@vger.kernel.org
>   W:	http://prism54.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
> -S:	Maintained
> +S:	Orphan
>   F:	drivers/net/wireless/p54/

Despite Michael's absence, p54 is still maintained. Christian is the most 
obvious choice for the position. If he is not willing to take on the 
responsibility, then I will.

Larry

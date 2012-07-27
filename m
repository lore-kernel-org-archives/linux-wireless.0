Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49060 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2G0MX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 08:23:28 -0400
Received: by obbuo13 with SMTP id uo13so4201420obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 05:23:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343391506.4449.11.camel@jlt3.sipsolutions.net>
References: <1343391506.4449.11.camel@jlt3.sipsolutions.net>
Date: Fri, 27 Jul 2012 17:53:27 +0530
Message-ID: <CAD2nsn2GDotMt8ts4uLsSYeHyddfvrkhNew+cq-ec9U_LztqhQ@mail.gmail.com> (sfid-20120727_142331_397975_945A1459)
Subject: Re: driver sparse/smatch warnings
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, Jul 27, 2012 at 5:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Since I was just running sparse & smatch anyway I figured I'd post it in
> case somebody is interested:
>
> http://p.sipsolutions.net/04cc4db35c4e5793.txt

thanks a lot! we will fix this up for ath9k.

>
> Drivers with seemingly relevant warnings are:
>  * ath9k (bad spin_lock_bh)
>  * b43 (some functions can be static)
>  * iwlegacy (lots of functions can be static)
>  * p54
>  * rt2x00 maybe?
>  * rtlwifi (null deref, endian warnings)
>  * at76c (dma on stack)
>
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi

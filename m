Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:58592 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbZHQLuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 07:50:35 -0400
Received: by fxm11 with SMTP id 11so2227288fxm.39
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 04:50:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908171000500.20447@pc-004.diku.dk>
References: <Pine.LNX.4.64.0908171000500.20447@pc-004.diku.dk>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 17 Aug 2009 13:50:16 +0200
Message-ID: <69e28c910908170450l65d493dbnb1d2e8f14d29dadc@mail.gmail.com>
Subject: Re: question about ieee80211_tx.c (fwd)
To: Julia Lawall <julia@diku.dk>
Cc: linux-wireless@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 10:03 AM, Julia Lawall<julia@diku.dk> wrote:
> The files ieee80211_tx.c in the directories
> drivers/staging/rtl8192su/ieee80211 and drivers/staging/rtl8192e/ieee80211
> both contain the following code in the function
> ieee80211_query_protectionmode:
>
>       if (ieee->mode == IW_MODE_MASTER)
>                        goto NO_PROTECTION;
>
> Elsewhere in these files when there is a comparison against an IW_MODE
> value, the field that is compared is iw_mode.  Should that be the case
> here as well?
>
> thanks,
> julia

I don't know; rtl8192su & rtl8192e use a modified version of the
libipw stack, rather than the mac80211 stack found behind non-staging
drivers.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:45163 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYLZUP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 15:15:28 -0500
Received: by rv-out-0506.google.com with SMTP id k40so3625963rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2008 12:15:26 -0800 (PST)
Message-ID: <b3153e950812261215mc7069dep60034ab4faaa7988@mail.gmail.com> (sfid-20081226_211533_245024_C82CF20D)
Date: Fri, 26 Dec 2008 12:15:26 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: techmin <info@techemia.com>
Subject: Re: 4965agn disassociating by local choice (reason=3)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49550F4B.8010304@techemia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <49550F4B.8010304@techemia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if you connect to the AP manually then make sure NM is not running or
just use NM to connect.

On Fri, Dec 26, 2008 at 9:07 AM, techmin <info@techemia.com> wrote:
> Please note:
> Problem on kernel 2.6.27-7/9/10
> with compat wireless 2008-12-11 and last compat wireless 2008-12-26
> i use wep.
>
> [ 2807.093457] wlan0: direct probe to AP XX:XX:4b:15:a5:a0 try 1
>                                           [ 2807.095392] wlan0 direct probe
> responded
>
> [ 2807.095403] wlan0: authenticate with AP XX:XX:4b:15:a5:a0
>
> [ 2807.097198] wlan0: authenticated
>
> [ 2807.097208] wlan0: associate with AP XX:XX:4b:15:a5:a0
>
> [ 2807.099484] wlan0: RX AssocResp from XX:XX:4b:15:a5:a0 (capab=0x431
> status=0 aid=3)                                 [ 2807.099493] wlan0:
> associated
>
> [ 2807.120643] wlan0: disassociating by local choice (reason=3)
>
> and wireless not work (ping ap non working and connection is down).
>
> iwlist wlan0 scan found the wireless network.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

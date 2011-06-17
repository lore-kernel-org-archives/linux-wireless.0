Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62628 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1FQEvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 00:51:25 -0400
Received: by wyb38 with SMTP id 38so53997wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 21:51:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=AM=mqmz7+hYGMwmVhFTHHd0o3Ug@mail.gmail.com>
References: <BANLkTi=AM=mqmz7+hYGMwmVhFTHHd0o3Ug@mail.gmail.com>
Date: Fri, 17 Jun 2011 10:21:23 +0530
Message-ID: <BANLkTik6sbqiEVpZkJxCW0c3H4JOMOtYfA@mail.gmail.com> (sfid-20110617_065130_119187_E3814F6B)
Subject: Re: can mesh(802.11s) be supported in 802.11n?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: b z <zb80211@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 15, 2011 at 6:13 PM, b z <zb80211@gmail.com> wrote:
> I have got 2 802.11n wireless routers using ralink rt3052f soc chip,mimo 2x2
> burned with openwrt (kernel 2.6.37.6, compat-wireless-2011-05-27)
>
> I configured them as mesh point respectively,  then
> #iw dev wlan0 station dump
>
> but the tx rate and rx rate still not exceed 54mbps, that is mean the
> ht mode(300mbps) is not been actived
>
> can anyone tell me how to active the 802.11n ht mode in mesh?
> it is the problem with mac80211 or rt2800pci driver?
> or mesh using 802.11n is not implemented in the current kernel?

yes HT mode is not yet supported in mesh (in mac80211). it should be
implemented in mac80211

>
> will it be implemented in the future?

some time back Luis sent this link
http://www.youtube.com/watch?v=sSUbCiEEP0k

> thank!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi

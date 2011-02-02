Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54291 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1BBK4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 05:56:46 -0500
Received: by wyb28 with SMTP id 28so7718008wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 02:56:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <10052860.45456.1296639849605.JavaMail.www@wwinf1e10>
References: <10052860.45456.1296639849605.JavaMail.www@wwinf1e10>
Date: Wed, 2 Feb 2011 16:26:44 +0530
Message-ID: <AANLkTi=sBohy=tiYJ00k5mMS2mUBRmztB9hRht1d-9js@mail.gmail.com>
Subject: Re: HOW TO enable UAPSD and WMM on ath9k
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Prigent Xavier MAPS LIS LANNION <labolis2@orange.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 2, 2011 at 3:14 PM, Prigent Xavier MAPS LIS LANNION
<labolis2@orange.fr> wrote:
>
> Hello ALL,
>
> I have an AR9280 on debian version 2.6.32. I tried to enable UAPSD and WMM on all queue but I can not. I install compat-
> wirelless and load ath9k.
> I saw with iw you can 't enable wmm or UAPSD. I remenbered with iwpriv you could do this but it does not work with this
> driver.
> I saw on" http://wireless.kernel.org/en/developers/Documentation/kerneldoc/include/net/mac80211.h" you could change WMM
> and UAPSD value.So I decide to make change in source and header code
> but it seems to be difficult and I does not understand all.
> * @IEEE80211_HW_SUPPORTS_UAPSD:
> * Hardware supports Unscheduled Automatic Power Save Delivery
> * (U-APSD) in managed mode. The mode is configured with
> * conf_tx() operation.

UAPSD is not supported in ath9k.I am saying this based on looking at
init.c of ath9k

>
> where is conf_tx() operation?
>
> Where I have to make change in order to enable WMM and UAPSD on all queue?
> Is there a CLI command?
>
> Thanks for your help,
>
> PX
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

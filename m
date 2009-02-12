Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from india533.server4you.de ([85.25.151.41]:28301 "EHLO
	india533.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZBLJMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 04:12:52 -0500
Message-ID: <4993E811.5040504@smash-net.org> (sfid-20090212_101257_382722_0CEB1BFC)
Date: Thu, 12 Feb 2009 10:12:49 +0100
From: =?ISO-8859-1?Q?Norman_Rie=DF?= <norman@smash-net.org>
MIME-Version: 1.0
To: Bob Copeland <bcopeland@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
References: <49931D52.90904@smash-net.org> <b6c5339f0902111304u430bce4dl3304f171ae8fbd45@mail.gmail.com>
In-Reply-To: <b6c5339f0902111304u430bce4dl3304f171ae8fbd45@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland schrieb:
> On Wed, Feb 11, 2009 at 1:47 PM, Norman Rie=DF <norman@smash-net.org>=
 wrote:
>  =20
>> Hello,
>>
>> i pulled wireless-testing kernel today and installed hostapd-0.6.7, =
 but
>> it still does not work.
>>
>>
>> iwconfig wlan0 mode master
>> Error for wireless request "Set Mode" (8B06) :
>>    SET failed on device wlan0 ; Invalid argument.
>>    =20
>
> Did you apply this patch from upthread?
>
> --- wireless-testing/drivers/net/wireless/ath5k/base.c      2009-02-1=
0
> 06:11:43.186470883 +0100
> +++ wireless-testing/drivers/net/wireless/ath5k/base.c.old
> 2008-11-14 09:36:40.000000000 +0100
> @@ -522,6 +501,7 @@
>        hw->wiphy->interface_modes =3D
>                BIT(NL80211_IFTYPE_STATION) |
>                BIT(NL80211_IFTYPE_ADHOC) |
> +               BIT(NL80211_IFTYPE_AP) |
>                BIT(NL80211_IFTYPE_MESH_POINT);
>
>        hw->extra_tx_headroom =3D 2;
>
>  =20
Arrrrg,
as i understood it, the newest pull did change that line, so i did not.
With that line added hostapd starts, and at first look, a bg2200 sees
the accesspoint with wpa2 capability.

Sorry for that.
Thanks
Norman

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

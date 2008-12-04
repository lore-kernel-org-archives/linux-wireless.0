Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:34415 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYLDOo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 09:44:56 -0500
Received: by qyk4 with SMTP id 4so4944724qyk.13
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 06:44:54 -0800 (PST)
Message-ID: <69e28c910812040644i1926aaf7wcf23f81c9dfe09e7@mail.gmail.com> (sfid-20081204_154500_332902_01C90543)
Date: Thu, 4 Dec 2008 15:44:54 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
Cc: "Christian Lamparter" <chunkeey@web.de>,
	"John W Linville" <linville@tuxdriver.com>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <4937E3DF.4030407@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net>
	 <69e28c910812040444l5d76632ah288078bd3db172d4@mail.gmail.com>
	 <200812041357.00103.chunkeey@web.de>
	 <69e28c910812040514l2d325eeekef3decbcce2520b2@mail.gmail.com>
	 <4937E3DF.4030407@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 4, 2008 at 3:06 PM, Larry Finger <Larry.Finger@lwfinger.net=
> wrote:
> Stefanik G=E1bor wrote:
>>
>>>From an AP ~5M from my antenna, both cards report around -45dBm. I
>> haven't tested the p54usb-based algorithm yet.
>
> Both the RTL8187 and the RTL8187B "calibrations" were done using a si=
ngle sample
> of each device, which is probably risky, but the best I could do.
>
> Is it possible for you to send me the quality and signal strength tha=
t you
> obtain for the RTL8187 at distances of a few cm, 3m and 10m from the =
AP? Please
> include which algorithm was used in the conversion.
>
> Thanks,
>
> Larry
>
>
>

Unfortunately that is not possible, as the RTL8187 is on the onboard
WiFi module of a desktop (P5K Premium), while the AP is a combined
ADSL modem+wireless router, so it must be placed near the ADSL wall
socket.

However, I am planning to get an Alfa AWUS036H (high-power RTL8187L
with known sensitivity levels) and an Argtek ARG-U25g (similar to the
Alfa, just RTL8187B-based), so I will be able to check the distance
where the connection drops (which corresponds to the sensitivy
levels).

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

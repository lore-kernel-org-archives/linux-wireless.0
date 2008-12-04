Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:54405 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbYLDNOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 08:14:12 -0500
Received: by qyk4 with SMTP id 4so4888844qyk.13
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 05:14:10 -0800 (PST)
Message-ID: <69e28c910812040514l2d325eeekef3decbcce2520b2@mail.gmail.com> (sfid-20081204_141415_478820_D6B37128)
Date: Thu, 4 Dec 2008 14:14:10 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W Linville" <linville@tuxdriver.com>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <200812041357.00103.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net>
	 <69e28c910812040444l5d76632ah288078bd3db172d4@mail.gmail.com>
	 <200812041357.00103.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 4, 2008 at 1:57 PM, Christian Lamparter <chunkeey@web.de> w=
rote:
> On Thursday 04 December 2008 13:44:09 Stefanik G=E1bor wrote:
>
>> BTW using RTL8187B's scaling constants for RTL8187L also work well
>> with this patch - I get almost identical readings from my BCM4318 an=
d
>> my RTL8187L. (I haven't yet submitted my version of the patch becaus=
e
>> it's pretty messy, with #if 0'd code and such.) I wonder whether b43
>> or p54usb is more correct... However, it looks like the same algorit=
hm
>> is applicable for both RTL8187 variants.
>>
> probably b43. p54usb uses static scaling constants to calculate
> signal & noise dbm, instead of finding the correct values from the de=
vice eeprom
> (Note: Link Quality doesn't substract the noise so it could be off ev=
en more).
>
> However, in my testing it was only a few +/- dbm(s), what's your read=
ing?
>

=46rom an AP ~5M from my antenna, both cards report around -45dBm. I
haven't tested the p54usb-based algorithm yet.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

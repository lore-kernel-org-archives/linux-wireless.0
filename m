Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56748 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbYF3Qq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 12:46:57 -0400
Message-ID: <48690E52.8040603@lwfinger.net> (sfid-20080630_184701_126280_7930630E)
Date: Mon, 30 Jun 2008 11:48:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Add quality output to iwlist and iwconfig
References: <4868fe45.swzEykllJP3Ow73U%Larry.Finger@lwfinger.net>	 <1214840530.5507.52.camel@johannes.berg>	 <486904D4.4010705@lwfinger.net> <69e28c910806300913m6ce12448m1326c3801d727273@mail.gmail.com>
In-Reply-To: <69e28c910806300913m6ce12448m1326c3801d727273@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
> On Mon, Jun 30, 2008 at 6:07 PM, Larry Finger <Larry.Finger@lwfinger.=
net> wrote:
>> Johannes Berg wrote:
>>> On Mon, 2008-06-30 at 10:39 -0500, Larry.Finger@lwfinger.net wrote:
>>>> The p54 driver family reports a quality of 0 in iwconfig and iwlis=
t
>>>> output. This patch calculates a quality number as a percentage of =
the
>>>> rssi to the maximum signal of 127 reported as the maximum signal.
>>> Unrelated, do you have a p54 card? Does it work? I wasn't sure whet=
her
>>> the tx-info sbk->cb change broke it or not after I fixed up some th=
ings
>>> there.
>> It is DW1450, which is a p54usb. It works with the latest wireless t=
esting,
>> at least in b/g/mode. I don't have an 802.11a AP to try the 5 GHz mo=
de.
 >
>=20
> What "special" modes work with it? (IBSS, monitor, AP, mesh, etc.)

I have only run it in managed mode. I bought it to use it in AP mode=20
to test my BCM4312 802.11a/b/g card when b43 can handle 5 GHz=20
channels, but that is for the future.

I gave a quick try of monitor mode with kismet. It saw the beacons=20
from nearby APs, but never captured any other packets. I don't think=20
it is working.

Larry


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

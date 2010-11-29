Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36025 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0K2Mle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 07:41:34 -0500
Message-ID: <4CF39F79.7070306@ti.com>
Date: Mon, 29 Nov 2010 14:41:29 +0200
From: Gery Kahn <geryk@ti.com>
Reply-To: geryk@ti.com
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: =?ISO-8859-1?Q?ext_G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl12xx: Remove 11j channels from the supported channels
 list.
References: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>	 <AANLkTikqg4+ERD6V+7P=2R_H2Q9bWuW3Jz6F=Kp4YKSC@mail.gmail.com> <1291033587.1673.39.camel@powerslave>
In-Reply-To: <1291033587.1673.39.camel@powerslave>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 02:26 PM, Luciano Coelho wrote:
> On Mon, 2010-11-29 at 13:06 +0100, ext Gábor Stefanik wrote:
>> On Mon, Nov 29, 2010 at 11:05 AM,<juuso.oikarinen@nokia.com>  wrote:
>>> From: Juuso Oikarinen<juuso.oikarinen@nokia.com>
>>>
>>> Because we don't support them at this stage.
>>>
>>> Signed-off-by: Juuso Oikarinen<juuso.oikarinen@nokia.com>
>>> ---
>>>   drivers/net/wireless/wl12xx/main.c |    8 --------
>>>   1 files changed, 0 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>>> index 7fecefe..dc3a093 100644
>>> --- a/drivers/net/wireless/wl12xx/main.c
>>> +++ b/drivers/net/wireless/wl12xx/main.c
>>> @@ -2374,14 +2374,6 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
>>>
>>>   /* 5 GHz band channels for WL1273 */
>>>   static struct ieee80211_channel wl1271_channels_5ghz[] = {
>>
>> Is this for WL1271 or WL1273? The comment contradicts the name...
>
> The wl1273 chip supports 5GHz channels.  The wl1271 chip doesn't.
>
> The driver supports both wl1271 and wl1273.  We have even changed the
> name to align with this (the driver is now called wl12xx).
>
> We changed the file names and the module names already, but we haven't
> changed the function and structure names yet.  At some point someone
> will s/wl1271/wl12xx/.  Yes, it is confusing as it is right now, so
> hopefully the renaming will happen soon.  Volunteers? ;)
>
is there enable_11a to use for?

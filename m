Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45468 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0AYTVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 14:21:31 -0500
Received: by bwz27 with SMTP id 27so2975061bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 11:21:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5DE859.6080409@lwfinger.net>
References: <4B5CD1FF.4090209@twilightblue.net> <b6c5339f1001250939r6d136927q51bba86f7102d826@mail.gmail.com>
	<4B5DE859.6080409@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 25 Jan 2010 20:21:09 +0100
Message-ID: <69e28c911001251121i61be9c0bhed43648a12db42f6@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	Don Darling <darling.don@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 25, 2010 at 7:52 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 01/25/2010 11:39 AM, Bob Copeland wrote:
>>
>> On Sun, Jan 24, 2010 at 6:04 PM, Don Darling<darling.don@gmail.com>
>>  wrote:
>>>
>>> I'm assuming this issue is related to the ath5k driver itself -- the
>>> network
>>> I'm using is only WEP128, and doesn't need wpa_supplicant.
>>
>> Huh, I didn't think any mac80211 driver supported WEP 128.  Are you sure
>> you
>> weren't using madwifi before?  Or maybe WEP 104?
>
> For the record, WEP104 and WEP128 are the same thing. The smaller number
> makes it explicit that the 24-bit IV is transmitted in the open. The same
> thing applies to WEP40 and WEP64.
>
> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Only one problem there is another, nonstandard WEP type where the
actual key is 128-bit, and this is also sometimes referred to as
WEP128 (with the same metric as WEP64, this one would be WEP152). Same
goes for "WEP228/WEP256/WEP280".

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

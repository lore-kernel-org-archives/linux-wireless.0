Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:10717 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbYF3QNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 12:13:48 -0400
Received: by yw-out-2324.google.com with SMTP id 9so782006ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 09:13:41 -0700 (PDT)
Message-ID: <69e28c910806300913m6ce12448m1326c3801d727273@mail.gmail.com> (sfid-20080630_181406_795085_0260823C)
Date: Mon, 30 Jun 2008 18:13:40 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Add quality output to iwlist and iwconfig
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <486904D4.4010705@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4868fe45.swzEykllJP3Ow73U%Larry.Finger@lwfinger.net>
	 <1214840530.5507.52.camel@johannes.berg>
	 <486904D4.4010705@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 6:07 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Johannes Berg wrote:
>>
>> On Mon, 2008-06-30 at 10:39 -0500, Larry.Finger@lwfinger.net wrote:
>>>
>>> The p54 driver family reports a quality of 0 in iwconfig and iwlist
>>> output. This patch calculates a quality number as a percentage of the
>>> rssi to the maximum signal of 127 reported as the maximum signal.
>>
>> Unrelated, do you have a p54 card? Does it work? I wasn't sure whether
>> the tx-info sbk->cb change broke it or not after I fixed up some things
>> there.
>
> It is DW1450, which is a p54usb. It works with the latest wireless testing,
> at least in b/g/mode. I don't have an 802.11a AP to try the 5 GHz mode.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

What "special" modes work with it? (IBSS, monitor, AP, mesh, etc.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37586 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbbAERaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 12:30:24 -0500
Received: by mail-ob0-f174.google.com with SMTP id nt9so68526183obb.5
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 09:30:24 -0800 (PST)
Message-ID: <54AACA29.3060709@lwfinger.net> (sfid-20150105_183027_540086_600C4E5D)
Date: Mon, 05 Jan 2015 11:30:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Christopher Chavez <chrischavez@gmx.us>,
	linux-wireless@vger.kernel.org
Subject: Re: p54usb kernel panic on recent mainline kernels
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com>	 <loom.20141227T010207-869@post.gmane.org> <2296382.VCr2c4tJc9@debian64>	 <5946673.YueIgFzjsn@debian64> <549EFC9F.9030504@lwfinger.net>	 (sfid-20141227_193826_833900_3E3C56C2) <1420450414.1898.6.camel@sipsolutions.net>
In-Reply-To: <1420450414.1898.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2015 03:33 AM, Johannes Berg wrote:
> On Sat, 2014-12-27 at 12:38 -0600, Larry Finger wrote:
>
>> I had redone the bisection and found that ca34e3b was the bad commit. That was
>> late last night (CST - UTC-5). I was pleased to find your patch in my mailbox
>> this morning.
>>
>> With your patch, my system has survived for about 2 hours, whereas it would have
>> failed in 2 minutes or less. You can add
>>
>> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> I think this needs to be applied to 3.{17-19}.
>
> Thanks everyone. I just sent out a revert - that'll be easier to manage
> for 3.17-3.19, and we can redo the original commit properly for 3.20.

That sounds good.

Larry



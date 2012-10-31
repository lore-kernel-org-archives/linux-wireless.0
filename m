Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62208 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2JaDYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 23:24:47 -0400
Message-ID: <509099FB.2080902@lwfinger.net> (sfid-20121031_042503_192607_78042F4E)
Date: Tue, 30 Oct 2012 22:24:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Ben Hutchings <ben@decadent.org.uk>,
	Albert Pool <albertpool@solcon.nl>, stable@vger.kernel.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: rtlwifi: rtl8192cu: Add new USB ID
References: <5090314E.7070703@solcon.nl> <201210302210.01258.chunkeey@googlemail.com> <509046CB.6020204@lwfinger.net> <201210302256.24497.chunkeey@googlemail.com>
In-Reply-To: <201210302256.24497.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2012 04:56 PM, Christian Lamparter wrote:
> On Tuesday, October 30, 2012 10:29:47 PM Larry Finger wrote:
>> On 10/30/2012 04:10 PM, Christian Lamparter wrote:
>>> On Tuesday, October 30, 2012 09:45:25 PM Ben Hutchings wrote:
>>>> On Tue, 2012-10-30 at 20:58 +0100, Albert Pool wrote:
>>>>> This is an ISY IWL 2000. Probably a clone of Belkin F7D1102 050d:1102.
>>>>> Its FCC ID is the same.
>>>>>
>>>>> Signed-off-by: Albert Pool <albertpool@solcon.nl>
>>>> [...]
>>>>
>>>> This is not the correct way to submit a change to stable.  See
>>>> Documentation/stable_kernel_rules.txt
>>>>
>>> Well, here's a quote from the author in the original post:
>>> "I can't get the device to connect to my wifi, but it at least detects
>>> networks with this patch. Probably a clone of Belkin F7D1102 050d:1102.
>>> Its FCC ID is the same."
>>>
>>> <http://www.spinics.net/lists/linux-wireless/msg98340.html>
>>>
>>> Unless this device is working now, I wouldn't recommend a Cc: stable.
>>
>> I got a private message from the OP that his AP was having a problem. He was
>> able to connect using the vendor driver, thus I have confidence that rtl8192cu
>> is the correct driver for the device.
> ok, I've included John in the Cc.
>
> John, can you please include this patch in your next 3.7 round?
> <https://patchwork.kernel.org/patch/1673541/>
>
> along with this tag:
>
> Cc: stable@vger.kernel.org
>
> [And maybe Larry can throw in his official ACK as well ;)]

Indeed. ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry





Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:40833 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121Ab2LMS5f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:57:35 -0500
From: Yogesh Powar <yogeshp@marvell.com>
To: Jonathan Bither <jonbither@gmail.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"j@w1.fi" <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Date: Thu, 13 Dec 2012 10:54:19 -0800
Subject: RE: ACS and Hostapd
Message-ID: <7DDF37406E10F0438561DBB78326DF390391C15265@SC-VEXCH1.marvell.com> (sfid-20121213_195740_639817_5FFF5BCB)
References: <20121123081444.GA6028@markyou.marvell.com>
 <20121211194249.GT15974@pogo>,<50C9F3FA.6000906@gmail.com>
In-Reply-To: <50C9F3FA.6000906@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>On 13/12/2012 8:57 PM, Jonathan Bither wrote:
>>On 12/11/2012 02:42 PM, Luis R. Rodriguez wrote:
>> On Fri, Nov 23, 2012 at 01:44:51PM +0530, Yogesh Ashok Powar wrote:
>>> Hi Luis,
>>>
>>> I was looking at your patches on the linux-wireless mailing list
>>> regarding ACS feature addition in hostapd.
>>>
>>> It is seen that you went till v8 patches and still the patches are not
>>> seen upstream?
>> Correct.
>>
>>> Is there any specific reason for this patches not being accepted?
>> It didn't get good test coverage and by the time I got results from Jouni
>> on his test I already lost interest on the code. If anyone wants to work
>> on it and enhance it feel free to do so.
>>
>>> I am refering http://marc.info/?l=linux-wireless&m=131257363303693 seems
>>> like all in one patch. But I have trouble finding correct git base for
>>> it; since patch doens't apply cleanly even when I take hostap.git back
>>> to Jul end of 2011. For v7, 1 through 3 apply cleanly but not 4th.
>>>
>>> Or I am I looking at some wrong hostapd git?
>> It should have been the same date / tag around when I submitted it. Sorry
>> I do not recall the exact commit.
>>
>>    Luis
>
>Hello Yogesh,
>     I myself was curious about the status of ACS. Thank you for
>following up about it. I have interest in this functionality and I would
>be happy to help test and assist with the implementation. I have devices
>which use ath5k, ath9k, and some misc broadcom chips.
>
>Thanks,
>Jonathan Bither

Hi Jouni/Luis,

It seems that, we have some resources that can be utilized to test this
feature of ACS for hostapd.

Before we begin on this work of Luis and optimize/enhance it further, would you
like to recommend some immediate changes from the last test results?

Thanks
Yogesh
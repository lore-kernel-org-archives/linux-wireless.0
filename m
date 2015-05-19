Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35996 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbESUSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 16:18:35 -0400
MIME-Version: 1.0
In-Reply-To: <5554E99A.5030302@broadcom.com>
References: <1431626160-10885-1-git-send-email-mcgrof@do-not-panic.com> <5554E99A.5030302@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 19 May 2015 13:18:14 -0700
Message-ID: <CAB=NE6WxMid+eNOoHZ__kbvP3BktHuYip+fQwVDydJQbQ1No_g@mail.gmail.com> (sfid-20150519_221855_454245_BCE5B1AE)
Subject: Re: [PATCH resend] README: clarify redistribution requirements
 covering patents
To: Arend van Spriel <arend@broadcom.com>
Cc: Kyle McMartin <kyle@kernel.org>, linux-firmware@kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2015 at 11:29 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/14/15 19:56, Luis R. Rodriguez wrote:
>> diff --git a/README b/README
>> index f2ed92e..d2a56ec 100644
>> --- a/README
>> +++ b/README
>> @@ -18,7 +18,10 @@ and also cc: to related mailing lists.
>>
>>   Your commit should include an update to the WHENCE file clearly
>>   identifying the licence under which the firmware is available, and
>> -that it is redistributable. If the licence is long and involved, it's
>> +that it is redistributable. Being redistributable includes ensuring
>> +the firmware license provided includes an implicit or explicit
>> +patent grant to end users to ensure full functionality of device
>> +operation with the firmware. If the licence is long and involved, it's
>
>
> Just nitpicking here, but there is 'license' and 'licence' being used here.
> Better stick to one and preferably 'license'.

Fixed, will submit a v2.

 Luis

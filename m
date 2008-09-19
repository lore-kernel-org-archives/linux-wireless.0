Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:42477 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbYISRzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 13:55:19 -0400
Received: by yw-out-2324.google.com with SMTP id 9so94991ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 10:55:18 -0700 (PDT)
Message-ID: <43e72e890809191055o4085fab1k8a85fe9266ae8aab@mail.gmail.com> (sfid-20080919_195523_476560_0154A873)
Date: Fri, 19 Sep 2008 10:55:18 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Kalle Valo" <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200809191658.46690.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <877i98iw4h.fsf@nokia.com>
	 <43e72e890809182257r65da8757g1de0ce4f132bf019@mail.gmail.com>
	 <1221814778.10419.23.camel@johannes.berg>
	 <200809191658.46690.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 7:58 AM, Christian Lamparter <chunkeey@web.de> wrote:
> On Friday 19 September 2008 10:59:38 Johannes Berg wrote:
>> On Thu, 2008-09-18 at 22:57 -0700, Luis R. Rodriguez wrote:
>> > > After the driver has received some serious cleanup I would like to try
>> > > to to get it into wireless-testing tree. But I'll send another email
>> > > later on.
>> >
>> > Cool! I thought n810 basically used a p54 type chipset over SPI?
>>
>> Yes, but the firmware (lower MAC) is sufficiently different that it
>> would be painful to support in p54, afaict.
>>
> not that much... only the frequency calibration data is a bit different,
> while most other data structures are more or less the same. Really!

Well to be fair we had similar question with ath5k and we went with
ath9k because that's how we best could support the hardware as quickly
as possible for users. Eventually we will converge though as it just
makes sense in areas that we can share. So if this driver is targeted
upstream to get users supported I can see how using a new driver
supported by a team can make sense. But eventually convergence should
be considered.

Is this driver targeted for inclusion upstream?

If the driver is targeted upstream and a company is sponsoring its
development we would like a license for the firmware. I mentioned this
on another thread but it must be one which meets distribution
requirements. You can see the WHENCE file on linux-firmware git tree
for examples.

git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git

Otherwise how can I use this driver, test it or enhance it?

  Luis

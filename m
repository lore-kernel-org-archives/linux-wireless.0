Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:57997 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZBJRTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 12:19:10 -0500
To: Dan Williams <dcbw@redhat.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano \(Nokia-D\/Helsinki\)" <Luciano.Coelho@nokia.com>
Subject: Re: wl12xx: driver for TI wl1251 chipset
References: <87iqnishuj.fsf@nokia.com> <1234279279.3119.12.camel@localhost>
	<87mycuxnum.fsf@nokia.com> <1234283159.3119.62.camel@localhost>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 10 Feb 2009 19:18:29 +0200
In-Reply-To: <1234283159.3119.62.camel@localhost> (ext Dan Williams's message of "Tue\, 10 Feb 2009 17\:25\:59 +0100")
Message-ID: <87iqnixlay.fsf@nokia.com> (sfid-20090210_181915_888478_C384DFAF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Dan Williams <dcbw@redhat.com> writes:

> On Tue, 2009-02-10 at 18:23 +0200, Kalle Valo wrote:
>> Dan Williams <dcbw@redhat.com> writes:
>>
>> >> production line tests and pushing the calibration data from user
>> >> space.
>> >
>> > When is the calibration data required
>>
>> When we boot the firmware, that is during interface up.
>>
>> > and is it likely to change at runtime?
>>
>> It's device specific. Each device is calibrated in the factory and the
>> calibration data is stored to a special partition in the device.
>
> By "special partition", you mean a filesystem?  Or something else?

A proprietary binary format in a mtd partition basically.

-- 
Kalle Valo

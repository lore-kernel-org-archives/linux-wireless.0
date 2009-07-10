Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53609 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZGJHB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 03:01:58 -0400
Received: by fxm18 with SMTP id 18so667950fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 00:01:55 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>,
	Christian Lamparter <chunkeey@web.de>,
	Alexander Wenzel <wenzel@fgan.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Problem with p54 driver and ibss mode
References: <4A55DB91.2070305@fgan.de> <200907092056.53055.chunkeey@web.de>
	<87vdm1pr5m.fsf@litku.valot.fi>
	<200907100143.29004.jcmvbkbc@gmail.com>
	<1247176098.1905.8.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 10 Jul 2009 10:01:52 +0300
In-Reply-To: <1247176098.1905.8.camel@johannes.local> (Johannes Berg's message of "Thu\, 09 Jul 2009 23\:48\:18 +0200")
Message-ID: <87my7d10nz.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > stlc45xx-cal pushes the device specific calibration data and sets the
>> > MAC address. It's recommended to run it to get optimal performance.
>> > 
>> IIRC stlc45xx-cal pushes these data into sysfs entries, which
>> stlc45xx used to create. There's no such interface in p54spi.

Oh yeah, I forgot that.

> Should be easy to copy the code into p54spi, we just never did, hoping
> Kalle would come up with a better way, maybe request_firmware() :)

I agree with you, better not to copy the sysfs interface to p54spi. I'm
planning to experiment with the firmware interface at some point, but it
would be great if someone else could take a look at it first.

-- 
Kalle Valo

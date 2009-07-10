Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48704 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZGJIgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 04:36:12 -0400
Received: by fxm18 with SMTP id 18so712374fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 01:36:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iqi10xi0.fsf@litku.valot.fi>
References: <4A55DB91.2070305@fgan.de> <200907092056.53055.chunkeey@web.de>
	 <87vdm1pr5m.fsf@litku.valot.fi>
	 <200907100143.29004.jcmvbkbc@gmail.com>
	 <1247176098.1905.8.camel@johannes.local>
	 <87my7d10nz.fsf@litku.valot.fi>
	 <73aaf0dd0907100043p7916c4fbid9aa2faa3580477d@mail.gmail.com>
	 <87iqi10xi0.fsf@litku.valot.fi>
Date: Fri, 10 Jul 2009 12:36:10 +0400
Message-ID: <73aaf0dd0907100136p6c8c560fq39d5287f010e52a3@mail.gmail.com>
Subject: Re: Problem with p54 driver and ibss mode
From: Max Filippov <jcmvbkbc@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	Alexander Wenzel <wenzel@fgan.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Basically we have been talking about fetching calibration data via the
> request_firmware() interface. In user space there would be a udev script
> which would dynamically retrieve the calibration data specific to the
> platform it is running on. In N800/N810 case that would mean to run
> stlc45xx-cal and provide the calibration data to the driver.
>
> This way we can have platform specific implementations and use already
> existing user space interface. The idea was discussed in this mailing
> list few months ago. The implementation details are currently unknown to
> me. I was planning to talk about this at the Wireless Summit, but of
> course I forgot :/
>
> stlc45xx-cal will most probably need some changes, maybe dumping the
> calibration data to stdout so that udev script can forward it to the
> driver? I can do the necessary changes to stlc45xx-cal, but it's better
> to have a some sort of working prototype before I'll start changing
> stlc45xx-cal.

Ok. Gonna make such prototype during this weekend.

-- 
Max

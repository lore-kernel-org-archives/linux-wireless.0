Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37903 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZGJHnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 03:43:50 -0400
Received: by fxm18 with SMTP id 18so686938fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 00:43:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87my7d10nz.fsf@litku.valot.fi>
References: <4A55DB91.2070305@fgan.de> <200907092056.53055.chunkeey@web.de>
	 <87vdm1pr5m.fsf@litku.valot.fi>
	 <200907100143.29004.jcmvbkbc@gmail.com>
	 <1247176098.1905.8.camel@johannes.local>
	 <87my7d10nz.fsf@litku.valot.fi>
Date: Fri, 10 Jul 2009 11:43:48 +0400
Message-ID: <73aaf0dd0907100043p7916c4fbid9aa2faa3580477d@mail.gmail.com>
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

>> Should be easy to copy the code into p54spi, we just never did, hoping
>> Kalle would come up with a better way, maybe request_firmware() :)
>
> I agree with you, better not to copy the sysfs interface to p54spi. I'm
> planning to experiment with the firmware interface at some point, but it
> would be great if someone else could take a look at it first.

I can take a look at it. (: But the question is... to take a look at
it to see what?

-- 
Max

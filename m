Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-02.mandic.com.br ([200.225.81.133]:47524 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2EaKnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 06:43:14 -0400
Message-ID: <4FC74B3C.1090501@cesarb.net> (sfid-20120531_124317_511101_2DAF7AC9)
Date: Thu, 31 May 2012 07:43:08 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: iwlwifi: GF was set with SGI:SISO
References: <4FC17BA8.2050606@cesarb.net>  (sfid-20120527_030308_122290_604E4002) <1338450650.4531.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338450650.4531.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em 31-05-2012 04:50, Johannes Berg escreveu:
> On Sat, 2012-05-26 at 21:56 -0300, Cesar Eduardo Barros wrote:
>> I have twice now seen a problem with iwlwifi where rate control gets
>> "stuck" (the tx bitrate as shown by "iw dev wlan0 link" does not change
>> anymore), while spamming the kernel log with "iwlwifi 0000:03:00.0: GF
>> was set with SGI:SISO".
>>
>> What I believe is happening is the following scenario:
> [...]
>
> Unfortunately, I don't have any idea right away right now what's going
> on. Would you file a bug on bugzilla.intellinuxwireless.org so we can
> track it and help you better? We may want to reproduce it and/or ask you
> to collect some tracing information and it's easier to collect all that
> in a bug report.

Filed as http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2361.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com

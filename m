Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52349 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab2FZIFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 04:05:33 -0400
Received: by eeit10 with SMTP id t10so1497210eei.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 01:05:32 -0700 (PDT)
Message-ID: <4FE96D48.9080901@gmail.com> (sfid-20120626_100540_194649_6E54065D)
Date: Tue, 26 Jun 2012 10:05:28 +0200
From: sylvain_gmail <sylvain.roger.rieunier@gmail.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Victor Goldenshtein <victorg@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add command to get current rssi
References: <1337669130-4229-1-git-send-email-victorg@ti.com> <4FE85430.3030007@gmail.com> <87y5nb34bm.fsf@purkki.adurom.net>
In-Reply-To: <87y5nb34bm.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it can be very useful when you installed multiple polarization antennas. 
For each polarization picks up the signal on a different axis. For 
example for a dual polarization antenna, you have a horizontal 
polarization and vertical polarization.

Regards,
Sylvain

Le 25/06/2012 15:32, Kalle Valo a écrit :
> sylvain_gmail <sylvain.roger.rieunier@gmail.com> writes:
>
>> But do not you think it would be interesting to have a function that
>> returns the RSSI signal by antennas?
> Just out of interest, how would user space use that information? Do you
> have any ideas?
>



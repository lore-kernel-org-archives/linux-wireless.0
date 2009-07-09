Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:35216 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZGITzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 15:55:53 -0400
Received: by bwz25 with SMTP id 25so420652bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 12:55:51 -0700 (PDT)
To: Christian Lamparter <chunkeey@web.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>,
	Alexander Wenzel <wenzel@fgan.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Problem with p54 driver and ibss mode
References: <4A55DB91.2070305@fgan.de> <4A560E4B.6080209@fgan.de>
	<200907092157.21784.jcmvbkbc@gmail.com>
	<200907092056.53055.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 09 Jul 2009 22:55:49 +0300
In-Reply-To: <200907092056.53055.chunkeey@web.de> (Christian Lamparter's message of "Thu\, 9 Jul 2009 20\:56\:52 +0200")
Message-ID: <87vdm1pr5m.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

>> These data for sure must reside on /dev/mtdblk1 partition, but
>> they're probably somehow coded/obfuscated. I couldn't find anything
>> similar to MAC of my own n810 there.
>
> well, this is c0ffee comes from nokia's stlc45xx-driver.
> Unfortunately, they don't say how to get the device eeprom from the
> mtdblk1 partition. However, they certainly provide a tool stlc45xx-cal
> (available at: http://stlc45xx.garage.maemo.org/ ) which can be used
> to locate the eeprom's calibration data.

stlc45xx-cal pushes the device specific calibration data and sets the
MAC address. It's recommended to run it to get optimal performance.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49950 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbZGIVnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 17:43:41 -0400
Received: by fxm18 with SMTP id 18so483817fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 14:43:39 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: Problem with p54 driver and ibss mode
Date: Fri, 10 Jul 2009 01:43:28 +0400
Cc: Christian Lamparter <chunkeey@web.de>,
	Alexander Wenzel <wenzel@fgan.de>,
	linux-wireless@vger.kernel.org
References: <4A55DB91.2070305@fgan.de> <200907092056.53055.chunkeey@web.de> <87vdm1pr5m.fsf@litku.valot.fi>
In-Reply-To: <87vdm1pr5m.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907100143.29004.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

В сообщении от Thursday 09 July 2009 Kalle Valo написал(a):
> Christian Lamparter <chunkeey@web.de> writes:
> 
> >> These data for sure must reside on /dev/mtdblk1 partition, but
> >> they're probably somehow coded/obfuscated. I couldn't find anything
> >> similar to MAC of my own n810 there.
> >
> > well, this is c0ffee comes from nokia's stlc45xx-driver.
> > Unfortunately, they don't say how to get the device eeprom from the
> > mtdblk1 partition. However, they certainly provide a tool stlc45xx-cal
> > (available at: http://stlc45xx.garage.maemo.org/ ) which can be used
> > to locate the eeprom's calibration data.
> 
> stlc45xx-cal pushes the device specific calibration data and sets the
> MAC address. It's recommended to run it to get optimal performance.
> 
IIRC stlc45xx-cal pushes these data into sysfs entries, which stlc45xx used to create.
There's no such interface in p54spi.

Thanks.
-- Max

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40593 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2DFDAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 23:00:32 -0400
Received: by eaaq12 with SMTP id q12so584611eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 20:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333649707.4108.46.camel@hp-dhlii>
References: <1333649707.4108.46.camel@hp-dhlii>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 6 Apr 2012 13:00:10 +1000
Message-ID: <CAGRGNgUZqvgtuEfJk7vZ0Y4mEzadTBj4G3VQwmTykvy0R9dp8g@mail.gmail.com> (sfid-20120406_050036_566827_BE7C7B24)
Subject: Re: N device with open source firmware
To: "David Lynch Jr." <dhlii@dlasys.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Fri, Apr 6, 2012 at 04:15, David Lynch Jr. <dhlii@dlasys.net> wrote:
> I am looking for recommendations for an 802.11N device that is well
> documented and has opensource firmware for a project.  I do nto care
> whether it is mPCI, USB, .... so long as there is good documentation on
> the chipset and good open source firmware as I will be making extensive
> firmware changes for testing purposes.

If I recall correctly, the ar9170 devices with the carl9170 driver use
an open source firmware and are 802.11n capable.

There was also an effort to produce a open source firmware for
broadcom devices, but I'm not sure what it's status is and what
progress they made.

Also, there's a GSoC project to open source the firmware for the USB
ath9k devices, (ath9k_htc) but I don't think any progress has been
made.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

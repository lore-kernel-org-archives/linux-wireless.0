Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33119 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbbAOTe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 14:34:27 -0500
Received: by mail-wi0-f170.google.com with SMTP id z2so285987wiv.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2015 11:34:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f46d043c061e8dd5c9050cb5990c@google.com>
References: <CACsJT9OOBcYNhNG6=+Q2EE4VHEvJ8_rJ3fr6gb9_3P4KpPPX3g@mail.gmail.com>
 <f46d043c061e8dd5c9050cb5990c@google.com>
From: Mike Purvis <mpurvis@clearpathrobotics.com>
Date: Thu, 15 Jan 2015 14:34:06 -0500
Message-ID: <CACsJT9M9LcHEuEa2mgAB2taYATZq4j_NeLq78w+=-VBvOw1NGw@mail.gmail.com> (sfid-20150115_203431_236422_43DE85C0)
Subject: Re: Delivery Status Notification (Failure)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm having an issue with the Centrino Advanced-N 6235 module. I'm running
Ubuntu Trusty, and I've tried both the 3.13 and 3.16 kernels. Haven't yet
tried 3.18.

What's weirdest about it is that the module actually works with full
functionality on an Advantech AIMB-274 (Q87 chipset) with the described
software configuration. However, when I plug the module into either a Gigabyte
J1800N or an ASRock IMB-152 (J1900), I get no bluetooth— no hci0 device
comes up at all in hciconfig dev or rfkill list.

My sense is that the 6235 is a very popular module, and low-cost celeron
motherboards are also pretty popular, so there must be others who have run
into this. Maybe people just don't use bluetooth, or don't expect it to
work on Linux?

Anyhow, here is a gist with the dmesg boot log and lshw output:

https://gist.github.com/mikepurvis/ee7bc8fb85ff7ae64a9d

Looks like there's a crash in there related to intel integrated graphics—
could this be a cause? This is a headless machine, so disabling graphics
completely is on the table, if someone can suggest a good way to go
about that. Any other ideas as to what's going on here?

Thanks muchly.

 --
Mike Purvis | Clearpath Robotics, Inc.
1425 Strasburg Road, Unit 2A , Kitchener, Ontario, N2R 1H2

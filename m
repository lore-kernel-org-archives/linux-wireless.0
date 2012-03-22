Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50728 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2CVEvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 00:51:00 -0400
Received: by lbbgm6 with SMTP id gm6so1448967lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2012 21:50:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120322002955.GA9391@aldebaran.gro-tsen.net>
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
	<CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
	<20120321220242.GA26363@aldebaran.gro-tsen.net>
	<20120322002955.GA9391@aldebaran.gro-tsen.net>
Date: Wed, 21 Mar 2012 21:50:56 -0700
Message-ID: <CAJ-Vmom-6XjtfbhOgbkUtAykKr==8sL+9r3HaQWJczumqBPmMw@mail.gmail.com> (sfid-20120322_055106_784106_0D6101C2)
Subject: Re: ath9k_htc fails with "Target is unresponsive"
From: Adrian Chadd <adrian@freebsd.org>
To: David Madore <david+ml@madore.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

That sounds like the USB code isn't doing a full reset of the hardware.

What about seeing if the SoC or controller has some form of cold USB
device reset and make sure that's being done at device driver attach
time?

Thanks,



Adrian

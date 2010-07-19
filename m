Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45564 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0GSX3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 19:29:38 -0400
Subject: Re: iwlagn and many firmware restarts with Fedora kernel
From: Marcel Holtmann <marcel@holtmann.org>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinGUQjPoMRmt_jeFgpxLhzma7qhfR14t_tWLvO1@mail.gmail.com>
References: <1279565034.4572.36.camel@localhost.localdomain>
	 <AANLkTinGUQjPoMRmt_jeFgpxLhzma7qhfR14t_tWLvO1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 16:29:34 -0700
Message-ID: <1279582174.4572.43.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > so during the last few weeks, I have seen a huge amount of firmware
> > restarts with my Intel 5350 card and Fedora 13 kernel (2.6.33.6-147).
> >
> > iwlagn 0000:03:00.0: low ack count detected, restart firmware
> > iwlagn 0000:03:00.0: On demand firmware reload
> > iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
> > iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19
> >
> > If this happens then I don't see it once, I normally see this 10-20
> > times and the connectivity is stalled until the cards comes back to
> > life. I have seen patches that should have fixed this symptom, but they
> > might be also send to -stable since this is a major hassle.
> >
> > The time without connectivity is something around 4-5 minutes or longer
> > when this happens. Not really funny.
> 
> This happens here too even with the 2.6.34.1-9.fc13.x86_64 kernel;
> when this happens reloading the iwlagn module seems to be the only
> (quick) way to get it back to life.

the quick way is re-loading the module, that is true. Otherwise you have
to sit it out. It always comes back nicely and starts working again.

Regards

Marcel



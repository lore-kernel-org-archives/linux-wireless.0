Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52637 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0GSX2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 19:28:42 -0400
Subject: RE: iwlagn and many firmware restarts with Fedora kernel
From: Marcel Holtmann <marcel@holtmann.org>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A350120692494@orsmsx506.amr.corp.intel.com>
References: <1279565034.4572.36.camel@localhost.localdomain>
	 <E9954878DD1FB34FAE5187FB88C58A350120692494@orsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 16:28:38 -0700
Message-ID: <1279582118.4572.42.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey,

> so during the last few weeks, I have seen a huge amount of firmware
> restarts with my Intel 5350 card and Fedora 13 kernel (2.6.33.6-147).
> 
> iwlagn 0000:03:00.0: low ack count detected, restart firmware
> iwlagn 0000:03:00.0: On demand firmware reload
> iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
> iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19
> 
> If this happens then I don't see it once, I normally see this 10-20
> times and the connectivity is stalled until the cards comes back to
> life. I have seen patches that should have fixed this symptom, but they
> might be also send to -stable since this is a major hassle.
> 
> The time without connectivity is something around 4-5 minutes or longer
> when this happens. Not really funny.
> 
> Which patch you referring to? I will try to work on submit it to stable.

no patch in particular, I just have seen some commit messages that would
be indicating this got fixed.

Regards

Marcel



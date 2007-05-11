Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36894 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760852AbXEKJIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 05:08:10 -0400
Message-ID: <46443266.4060102@garzik.org>
Date: Fri, 11 May 2007 05:07:50 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz> <46437DC8.2060805@linux.intel.com> <20070510212355.6c13cde8@griffin.suse.cz> <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com> <20070511001212.GB6971@tuxdriver.com> <464424A7.2040301@warmcat.com>
In-Reply-To: <464424A7.2040301@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> Sexy-sounding "hw offloading" is a very different thing to migrating off
> open code and putting it in vendor-specific closed source firmware.  The
> firmware is just code like any other, for an embedded ARM7 or similar,
> except that it is customized for a specific vendor hardware
> implementation and you will never see the sources.  What I understand is
> being talked about (maybe unlike the scan stuff this actually is in
> hardware, but I doubt it) is ignoring code in the stack and instead
> implementing pretty much the same code privately, to compile to a binary
> blob you can't see source for or even reverse according to its license.
>  That is a lot less romantic than mysterious hardware just waiting to be
> used.

OTOH, this is all vague, paranoid hand-waving since I'm guessing you 
don't know the internals of the Intel hardware.

We'll see what happens when Intel posts code to specify a different rate 
control algorithm.

	Jeff



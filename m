Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:3940 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbXBDUq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 15:46:28 -0500
Received: by wr-out-0506.google.com with SMTP id i22so1072975wra
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2007 12:46:27 -0800 (PST)
Message-ID: <9e4733910702041246s750fc8ach73e29a8c17727145@mail.gmail.com>
Date: Sun, 4 Feb 2007 15:46:27 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: SoftMAC vs FullMAC
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200702042111.17005.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
	 <200702042007.29357.mb@bu3sch.de>
	 <9e4733910702041144n277facd1g6af9c4659afc6d39@mail.gmail.com>
	 <200702042111.17005.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/4/07, Michael Buesch <mb@bu3sch.de> wrote:
> I don't really see your point.
> We can't change hardware. We have to implement the software around existing
> hardware. And that's currently softmac _and_ fullmac devices.
> So we have to create hooks and so on in our software to support
> the fullmac devices.

What happened at Microsoft in the Ethernet case is that MS stopped
supporting FullMAC and told the vendors to come up with SoftMAC type
drivers. For some cards the vendors wrote the software drivers and for
others MS did. Not all of the vendors agreed to this and most of those
companies are no longer around.

The point is that Linux could simply design out the FullMAC hardware
that didn't also make a basic SoftMAC interface available. The primary
wireless implementation for Linux would be a fully software based
implementation that all hardware would be required to minimally work
with. The main kernel wireless developers would then focus their
attention on the software stack implementation instead of dealing with
all of the various firmware messes and uncooperative vendors.

This model is pretty close to happening with the Dscape stack. Once
Dscape goes in, notice could be given that the other implementations
will be removed in a year.

Of course Linux doesn't have the same kind of power over the vendors
like MS does. But it doesn't mean that this model wouldn't work for
Linux. The concept of a single top to bottom software based reference
implementation with hooks for hardware acceleration is a sound design.

-- 
Jon Smirl
jonsmirl@gmail.com

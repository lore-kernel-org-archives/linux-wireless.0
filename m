Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50101 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2JaF25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 01:28:57 -0400
Message-ID: <5090B711.70808@candelatech.com> (sfid-20121031_062922_167990_36B0F652)
Date: Tue, 30 Oct 2012 22:28:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Julian Calaby <julian.calaby@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Any thoughts on how to best shield u.fl connectors on NICs?
References: <508EB783.9080000@candelatech.com> <CAGRGNgWGfL+_u4fHEfqZAcFHb1H4Z4jFkiE4qKLU6i9XEWzZ6w@mail.gmail.com> <5090560D.1090708@candelatech.com> <CAGRGNgUQ40YW-dwy34nPD65XPWt1VWetyXDdd=L_NxKJ9-_Fiw@mail.gmail.com> <CAJ-Vmoky+46E71wQbF1-J-xEnHdWeMMXf=Yo+SGkqALjvjrJrg@mail.gmail.com>
In-Reply-To: <CAJ-Vmoky+46E71wQbF1-J-xEnHdWeMMXf=Yo+SGkqALjvjrJrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2012 10:16 PM, Adrian Chadd wrote:
> On 30 October 2012 16:45, Julian Calaby <julian.calaby@gmail.com> wrote:
>
>> That's a good point, all the NICs I've looked at closely (e.g. the
>> rt2500usb cards on my desk at the moment) have an antenna or u.fl
>> connector with some passive components around it and usually the
>> antenna trace runs exposed on the board for a couple of millimetres
>> before it disappears under the shielding around the RF chip. I'll
>> check my collection at home tonight, but I'm pretty sure that all the
>> PCI cards have a couple of cm of exposed antenna trace between the SMA
>> connector and the RF shield.
>
> I've even seen ${COMMERCIAL} kit do this internally.

 From what I can tell, the WPEA-127n has a 1cm or so unshielded
run from the u.fl mounts to the RF chip logic.  I'm guessing this
acts as a mini-antenna, and maybe it was done that way on purpose,
but it's all guessing at this point.

>
> Ben, what are you worried about in particular?

Two things come to mind:

First, I'd like to put 2+ NICs close together in the same chassis.
Would be nice if they were as isolated from each other as possible
so that each NIC could work independently of the other (once I can
get to SMA connectors, there are > 90db shielded cable options,
but of course it could just go to antenna where it all mixes again
anyway).

Second:  If one wants to use an attenuator and coax cables to connect
AP and Station systems together, the AP and Station need to NOT also
be transmitting through the air.  Anything I can do to keep that
over-the-air communication minimal should help.

Truth is, I'm not sure how much it really matters, but after a few weeks
of poking at cabling and such, I've gotten kind of curious :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



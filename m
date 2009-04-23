Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49966 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZDWKgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 06:36:35 -0400
Received: by ewy24 with SMTP id 24so424797ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 03:36:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240442334.14995.12.camel@localhost.localdomain>
References: <5b8543210904220608l484d0d2dv73b0d66cdc167ce@mail.gmail.com>
	 <1240442334.14995.12.camel@localhost.localdomain>
Date: Thu, 23 Apr 2009 12:36:33 +0200
Message-ID: <5b8543210904230336j177998c4m1e0af03fbb3584df@mail.gmail.com> (sfid-20090423_123638_386390_3F8D98D2)
Subject: Re: Measure RSSI in adhoc networks
From: Kai Timmer <email@kait.de>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/23 Dan Williams <dcbw@redhat.com>:
> You can only get an RSSI if there are other nodes in the network, and
> then you get the RSSI of *that* node, as received by your node. =C2=A0=
You
> can't measure your own RSSI, because RSSI =3D *Received* Signal Stren=
gth
> Indicator, and you can't really receive your own traffic since you're
> radiating tons of power on TX and that completely deafens the RX chai=
n.

Ok, that was clear to me. I don't know where you read that i want my
own RSSI? That would just make no sense.

> Not all drivers report RSSI in adhoc mode at this time. =C2=A0But eve=
n if
> they did, they could only report RSSI when they receive a beacon or
> traffic from some other node in the adhoc network, and that's pretty
> useless because it doesn't give you a general quality of the "network=
",
> it gives you a specific quality of the radio path between two points =
in
> the network.

Maybe i should point out, what i am trying to do :)
I need the RSSI values for distance measurements between the nodes. So
what i need is not a "quality value" for the whole network, but the
recieved mW from every reachable point in the network. So i think the
RSSI value for every network node (if i can print them out seperatly)
should do the job.

Greets,
--=20
Kai Timmer
Email : email@kait.de
Jabber: kai@kait.de
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

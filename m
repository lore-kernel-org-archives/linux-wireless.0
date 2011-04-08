Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm29-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.144]:27174 "HELO
	nm29-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752636Ab1DHQg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 12:36:56 -0400
Message-ID: <768443.34687.qm@web161607.mail.bf1.yahoo.com>
Date: Fri, 8 Apr 2011 09:31:26 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Questions about rt2800usb
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Steev Klimaszewski <steev@genesi-usa.com>,
	Jett Chen <jett_chen@ralinktech.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <201104081441.32833.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Walter Goldens:
> > Further investigation suggests the DUP! packets stem
> from one specific AP.
> > Different APs seem to have less duplicate packets and
> overall packet-loss.
> > Its puzzling to me however that the said AP does not
> produce DUP! packs
> > at all with rt2870sta.
> 
> Is the AP 11n capable? Could you try to get a wifi capture
> when these
> duplicates happen (with a second station in monitor mode)?

Hi Helmut,

Your question about the 11N AP sparked interesting results. An 11n capable AP, but connected to a 54G mode did NOT produce a _single_ DUP! packet! Well over 2000 packets transmitted, not a single one duplicate. 

This clearly isolates the problem to 54 B/G-Only APs. 

Regarding your request for a capture file where duplicate packets occur, I have this to ask. I found out rt2800usb has the ability to switch to monitor mode - while connected to the AP and the gateway is ping-able. Will a capture from the same PC connected to the AP do the job for analysis? It will take me some time to set up a second station running the rt2800usb module and capture communications between the AP and the said PC.

Please let me know.

Walter

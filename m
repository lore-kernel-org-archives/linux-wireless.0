Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2135 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623Ab2J0STZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2012 14:19:25 -0400
Message-ID: <508C259F.8010909@broadcom.com> (sfid-20121027_201935_782792_97849C79)
Date: Sat, 27 Oct 2012 20:19:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Adrian Chadd" <adrian@freebsd.org>
cc: "Ben Greear" <greearb@candelatech.com>,
	"Kelly Hogan" <kshogan@bluemesh.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Is Multi-Vif (vaps) Different Channel Operation Supported?
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
 <50880BD0.6080603@candelatech.com>
 <1351093332.10709.5.camel@jlt4.sipsolutions.net>
 <5DA0F03B-BA8C-4D9F-A9F1-0841D6774255@bluemesh.net>
 <50888021.4050300@candelatech.com>
 <CAJ-Vmo=eP8EC2760A_0Ydy3bvG93bhVXfHS9TS3VpAf2vejJ=g@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=eP8EC2760A_0Ydy3bvG93bhVXfHS9TS3VpAf2vejJ=g@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2012 10:19 AM, Adrian Chadd wrote:
> Yeah, how's hostap mode supposed to work in that case? The hostap
> interface doesn't go into and out of power save like stations can. It
> has to be ready to receive anything from any STA, at any point in
> time.

In my Intersil/Conexant days there was a marketing dude coming up with 
'time-slicing AP' and there was a way to signal STAs the AP was not able 
to receive. Just needed to be back in time to send its beacon. I chose 
to forget all about the bad idea.

Gr. AvS


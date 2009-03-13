Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54480 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZCMEsD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 00:48:03 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 21:48:02 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.58504.252509.729185@gargle.gargle.HOWL> (sfid-20090313_054818_787315_70D8DB56)
Date: Fri, 13 Mar 2009 10:13:52 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Which APs to disregards from in inputting into the bss list
In-Reply-To: <43e72e890903122118p5533bb4eke512f947c8879edf@mail.gmail.com>
References: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
	<18873.53124.115355.862512@gargle.gargle.HOWL>
	<43e72e890903122118p5533bb4eke512f947c8879edf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Thu, Mar 12, 2009 at 8:14 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> > Luis R. Rodriguez wrote:
> >> Do we want to ignore certain APs if we determine they are bogus? An
> >> example is 11n APs with WEP/TKIP.
> >
> > They are not bogus, we just fall back to legacy association.
> 
> What if its HT only.
> 

It should deny association, since we send only legacy capabilities
in our assoc request. But I doubt that HT-only APs exist.

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:51846 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755708Ab1AGXAo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 18:00:44 -0500
Message-ID: <20110107230042.15081.qmail@stuge.se>
Date: Sat, 8 Jan 2011 00:00:42 +0100
From: Peter Stuge <peter@stuge.se>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Aleksandar Milivojevic <alex@milivojevic.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com> <AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com> <20110107024432.GC20431@tux> <201101071111.17423.helmut.schaa@googlemail.com> <AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com> <20110107202224.GI21588@tux> <20110107221305.6484.qmail@stuge.se> <AANLkTikL0ONLAd7qncZtafRpxQh1jBG9_xs5xPjTgAxT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTikL0ONLAd7qncZtafRpxQh1jBG9_xs5xPjTgAxT@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> >>         bgscan="simple:30:-45:300"
> > ..
> >> No Linux distributions today uses this other than ChromeOS, but
> >> they should all change to use it.
> >
> > Maybe wpa_supplicant should be changed to use it by default?
> 
> The supplicant is configured by dbus,

In some realities, this is true. In many others it is not.


> so its not up to the supplicant by design.

It has a default value. If there is another, more correct, value to
use as default then maybe it should be changed?


> What has to change is Network Manager and connman needs to change
> to use bgscan by default.

That's also true.

But the correct place for sane defaults is not the top layer of a
stack, it is of course *every* layer of the stack.


//Peter

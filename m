Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f172.google.com ([209.85.219.172]:51161 "EHLO
	mail-ew0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0CDKSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 05:18:15 -0500
Subject: Re: Linux Bluetooth Coexistence documentation in general and for
 ath9k
From: Bastien Nocera <hadess@hadess.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"Kevin Hayes\" <kevin@atheros.com>, \"Dan Tian\""
	<Dan.Tian@atheros.com>
In-Reply-To: <43e72e891003032109v59f1ff52odb60de6111cfec53@mail.gmail.com>
References: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com>
	 <1267664353.10407.1960.camel@localhost.localdomain>
	 <43e72e891003032109v59f1ff52odb60de6111cfec53@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 04 Mar 2010 10:18:11 +0000
Message-ID: <1267697891.10407.3082.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-03 at 21:09 -0800, Luis R. Rodriguez wrote:
> On Wed, Mar 3, 2010 at 4:59 PM, Bastien Nocera <hadess@hadess.net> wrote:
> > On Wed, 2010-03-03 at 16:43 -0800, Luis R. Rodriguez wrote:
> >> Marcel, a question for you below.
> >>
> >> The question of Bluetooth coexistence pops up here, on IRC and on bug
> >> reports quite too often so I've stuffed what I could onto a page with
> >> a few references / code and about ath9k's schemes for BT coexistence,
> >> feel free to extend or correct:
> > <snip>
> >> I do wonder if this could be useful to network applets like network
> >> manager/connman.
> >
> > Not really. To me, it sounds like a "make it work" button. The kernel
> > bits of Bluetooth should already have an idea of when a device is
> > connected, so the kernel should be able to "do the right thing".
> >
> > Having options over what "the right thing" is is probably a good idea
> > whilst the kinks are worked out from the default behaviour, but this is
> > not something that should be advertised to users.
> 
> I wasn't really thinking of buttons for BT coex, but instead just
> information exposed out and making it available. Reason for this is
> users tend to be blind about btcoex stuff and it would be nice if we
> had a way to inform the user of the btcoex mechanisms that actually
> are being used. Does that change your answer?

No, not really. It could be useful as a debugging statement in the
kernel, or in bluetoothd might be helpful, but I'm not sure why users
would need to be told about the BT coex support, or what type is being
used.

It's probably too much information for the users. Though if it's
available in the kernel, one could get it fairly easily if enquiring.

Cheers


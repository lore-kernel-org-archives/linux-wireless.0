Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out110.alice.it ([85.37.17.110]:3141 "EHLO
	smtp-out110.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab0EDReH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 13:34:07 -0400
Subject: Re: [Fwd: USB AP card and/or rt2870 issue]
From: GNUtoo <GNUtoo@no-log.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <q2na32f33a41005040832n7d50a934q4ff0a6a4dde53f28@mail.gmail.com>
References: <1272986923.2486.45.camel@gnutoo-desktop>
	 <q2na32f33a41005040832n7d50a934q4ff0a6a4dde53f28@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 19:33:51 +0200
Message-ID: <1272994431.2447.0.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 17:32 +0200, Ivo Van Doorn wrote:
> On Tue, May 4, 2010 at 5:28 PM, GNUtoo <GNUtoo@no-log.org> wrote:
> > hi, I sent the following mail(attached) to the hostapd mailing list,but
> > Now I think It's a driver issue.
> > Is it possible to make an access point with a rt2870 card.
> > Does the driver support it?
> > I don't have much hope for now as it is a staging driver...and it
> > displayed a warning about that in dmesg...
> 
> You could try compat-wireless and the rt2800usb driver.
> That one actually does have Master mode support, but doesn't work
> on all cards yet. rt2800usb is also found in the main kernel tree, but
> using compat-wireless will give you the most recent version with
> _many_ fixes applied to it. :)
I tried that,
hostapd put the card in master mode
unfortunately once in master mode,impossible to find the essid when
scanning.

Denis.



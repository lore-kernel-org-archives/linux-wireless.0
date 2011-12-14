Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1LNWzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 17:55:14 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Wolfgang Breyha <wbreyha@gmx.net>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CALSq=BauniFumdhaSRXn2myh8oL7=7wFkkXGJFo8mdQYmddFeA@mail.gmail.com> (sfid-20111214_235154_524302_D0498605)
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron> <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 <1323455216.3622.21.camel@jlt3.sipsolutions.net> <4EE35877.1060507@gmx.net>
	 <1323680657.3442.7.camel@jlt3.sipsolutions.net> <4EE5D2D3.406@gmx.net>
	 <1323684754.3442.36.camel@jlt3.sipsolutions.net> <4EE5E3CD.1070409@gmx.net>
	 <1323712082.3442.43.camel@jlt3.sipsolutions.net> <4EE64522.5090107@gmx.net>
	 <1323790688.3355.24.camel@jlt3.sipsolutions.net> <4EE8B12C.4090906@gmx.net>
	 <1323900627.3599.4.camel@jlt3.sipsolutions.net>
	 <CALSq=BauniFumdhaSRXn2myh8oL7=7wFkkXGJFo8mdQYmddFeA@mail.gmail.com>
	 (sfid-20111214_235154_524302_D0498605)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 23:55:08 +0100
Message-ID: <1323903308.3599.8.camel@jlt3.sipsolutions.net> (sfid-20111214_235518_389151_1EF093AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-14 at 14:51 -0800, Daniel Halperin wrote:
> On Wed, Dec 14, 2011 at 2:10 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> > Maybe we somehow invented the best fuzzer ever? Wrongly decrypted
> > packets being sent up without being dropped, and your video stream and
> > firefox hating random binary data in the middle of the input?
> >
> 
> Seems unlikely---how would random binary data get properly put into
> the right TCP streams...

Hm, good point. So memory corruption in the applications using the
network? Why would it be restricted to those applications? (not to even
mention why would it be restricted to 32-bit kernels on 64-bit systems
then?)

I wish I could reproduce it, maybe it would be possible to bisect?

johannes


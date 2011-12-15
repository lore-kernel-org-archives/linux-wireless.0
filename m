Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1LONBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 08:01:10 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE9437F.1060500@gmx.net> (sfid-20111215_014727_969721_A7C059DE)
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron> <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 <1323455216.3622.21.camel@jlt3.sipsolutions.net> <4EE35877.1060507@gmx.net>
	  <1323680657.3442.7.camel@jlt3.sipsolutions.net> <4EE5D2D3.406@gmx.net>
	  <1323684754.3442.36.camel@jlt3.sipsolutions.net>
	 <4EE5E3CD.1070409@gmx.net> <1323712082.3442.43.camel@jlt3.sipsolutions.net>
	 <4EE64522.5090107@gmx.net> <1323790688.3355.24.camel@jlt3.sipsolutions.net>
	 <4EE8B12C.4090906@gmx.net>  <1323900627.3599.4.camel@jlt3.sipsolutions.net>
	 <CALSq=BauniFumdhaSRXn2myh8oL7=7wFkkXGJFo8mdQYmddFeA@mail.gmail.com>
	 (sfid-20111214_235154_524302_D0498605) <1323903308.3599.8.camel@jlt3.sipsolutions.net>
	 <4EE9437F.1060500@gmx.net> (sfid-20111215_014727_969721_A7C059DE)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 14:01:05 +0100
Message-ID: <1323954065.3337.43.camel@jlt3.sipsolutions.net> (sfid-20111215_140115_964308_EC2E2BF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-15 at 01:46 +0100, Wolfgang Breyha wrote:
> On 14/12/11 23:55, Johannes Berg wrote:
> > I wish I could reproduce it, maybe it would be possible to bisect?
> 
> I was able to build and test the following releases of compat-wireless:
> compat-wireless-2011-10-12
> compat-wireless-2011-09-27
> compat-wireless-2011-08-27
> compat-wireless-2011-08-26
> 
> All are affected in the same way. 2011-10-12 gave me a hard system
> freeze without output to messages. Most likely the "worst case scenario"
> of the issue.
> 
> compat-wireless-2011-08-23 and some older releases I tried do not build
> on F16 3.1.4.
> 
> IIRC 2011-03-25 was the release I used with F14.

Ok, thanks. That's a long time since known good, probably won't help
much unfortunately.

I'm not even sure tracing would help here since evidently something is
going completely wrong. I think we'll have to try harder to reproduce it
in our lab.

johannes


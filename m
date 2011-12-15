Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46330 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751366Ab1LOTrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 14:47:08 -0500
Message-ID: <4EEA4EB5.1060200@gmx.net> (sfid-20111215_204713_106411_478B164C)
Date: Thu, 15 Dec 2011 20:47:01 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi havoc on some APs (rekeying?)
References: <4EE2202A.4080303@gmx.net>  <1323446534.13074.96.camel@wwguy-huron> <4EE24DF4.4020301@gmx.net>  <1323451436.13074.158.camel@wwguy-huron>  <1323455216.3622.21.camel@jlt3.sipsolutions.net> <4EE35877.1060507@gmx.net>   <1323680657.3442.7.camel@jlt3.sipsolutions.net> <4EE5D2D3.406@gmx.net>   <1323684754.3442.36.camel@jlt3.sipsolutions.net>  <4EE5E3CD.1070409@gmx.net> <1323712082.3442.43.camel@jlt3.sipsolutions.net>  <4EE64522.5090107@gmx.net> <1323790688.3355.24.camel@jlt3.sipsolutions.net>  <4EE8B12C.4090906@gmx.net>  <1323900627.3599.4.camel@jlt3.sipsolutions.net>  <CALSq=BauniFumdhaSRXn2myh8oL7=7wFkkXGJFo8mdQYmddFeA@mail.gmail.com>  (sfid-20111214_235154_524302_D0498605) <1323903308.3599.8.camel@jlt3.sipsolutions.net>  <4EE9437F.1060500@gmx.net> (sfid-20111215_014727_969721_A7C059DE) <1323954065.3337.43.camel@jlt3.sipsolutions.net>
In-Reply-To: <1323954065.3337.43.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-15 14:01, Johannes Berg wrote:
> Ok, thanks. That's a long time since known good, probably won't help
> much unfortunately.
> 
> I'm not even sure tracing would help here since evidently something is
> going completely wrong. I think we'll have to try harder to reproduce it
> in our lab.

I was just testing your suggestion to use swcrypto=1 with iwlwifi from last
week and again the result is more than surprising.

If I set it the issue appears immediately on *BOTH* APs regardless of
rekeying. I expected the exact opposite at best!?

I will continue trying with F15 now... stay tuned;-)

Greetings, Wolfgang
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria

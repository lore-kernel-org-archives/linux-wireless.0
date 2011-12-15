Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46422 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755628Ab1LOAq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 19:46:59 -0500
Message-ID: <4EE9437F.1060500@gmx.net> (sfid-20111215_014702_943332_D9C08D07)
Date: Thu, 15 Dec 2011 01:46:55 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi havoc on some APs (rekeying?)
References: <4EE2202A.4080303@gmx.net>  <1323446534.13074.96.camel@wwguy-huron> <4EE24DF4.4020301@gmx.net>  <1323451436.13074.158.camel@wwguy-huron>  <1323455216.3622.21.camel@jlt3.sipsolutions.net> <4EE35877.1060507@gmx.net>  <1323680657.3442.7.camel@jlt3.sipsolutions.net> <4EE5D2D3.406@gmx.net>  <1323684754.3442.36.camel@jlt3.sipsolutions.net> <4EE5E3CD.1070409@gmx.net>  <1323712082.3442.43.camel@jlt3.sipsolutions.net> <4EE64522.5090107@gmx.net>  <1323790688.3355.24.camel@jlt3.sipsolutions.net> <4EE8B12C.4090906@gmx.net>  <1323900627.3599.4.camel@jlt3.sipsolutions.net>  <CALSq=BauniFumdhaSRXn2myh8oL7=7wFkkXGJFo8mdQYmddFeA@mail.gmail.com>  (sfid-20111214_235154_524302_D0498605) <1323903308.3599.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1323903308.3599.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/12/11 23:55, Johannes Berg wrote:
> I wish I could reproduce it, maybe it would be possible to bisect?

I was able to build and test the following releases of compat-wireless:
compat-wireless-2011-10-12
compat-wireless-2011-09-27
compat-wireless-2011-08-27
compat-wireless-2011-08-26

All are affected in the same way. 2011-10-12 gave me a hard system
freeze without output to messages. Most likely the "worst case scenario"
of the issue.

compat-wireless-2011-08-23 and some older releases I tried do not build
on F16 3.1.4.

IIRC 2011-03-25 was the release I used with F14.

Greetings, Wolfgang

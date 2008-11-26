Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49736 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbYKZRRm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 12:17:42 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 09:17:42 -0800
Date: Wed, 26 Nov 2008 09:17:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Michael Renzmann <mrenzmann@madwifi-project.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	Richard Farina <sidhayn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@Atheros.com>
Subject: Re: wireless-regdb: flaw in general functionality
Message-ID: <20081126171740.GB6515@tesla> (sfid-20081126_181745_927526_D1B2F238)
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla> <1227568883.28878.15.camel@dv> <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com> <492B623E.5030202@gmail.com> <1227580299.32415.2.camel@dv> <20081126001942.GN5950@tesla> <1227659754.2556.11.camel@dv> <20081126010218.GP5950@tesla> <1417.92.50.109.198.1227678824.squirrel@webmail.madwifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1417.92.50.109.198.1227678824.squirrel@webmail.madwifi.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 09:53:44PM -0800, Michael Renzmann wrote:
> Hi.
> 
> Luis R. Rodriguez wrote:
> > When in a DFS freq, if you don't support DFS in your mode of operation,
> > then you cannot TX.
> 
> Side note: this behaviour is not required in all jurisdictions. German
> regulatory body for example allows use of non-DFS-compliant gear even on
> (at least some) DFS channels, but only with low TX power. Is that
> supported already?

Michael,

I reviewed this internally and there is disagreement on your statement
about German rules. Perhaps there is also a terminology disconnect
between "DFS" and "Radar Detection" and how this applies to a STA or an
AP.

For STA devices "DFS" is required for all Europe regdomains including
Germany for channels 52 to 140 inclusive. "DFS" for STAs means passive
scanning and no adhoc for STA devices (or Mesh, hence NO-BEACONING name
suggestion for the flag).

When on AP and on these channels the AP must do radar detection, in
Germany and rest of Europe and in all other regions. Radar detection
includes a bunch of required functions for APs which we won't get into
on this thread.

Perhaps you are thinking of old interim rules that applies in Germany
and elsewhere. But they no longer apply anyway in Europe.

  Luis

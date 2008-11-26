Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:52587 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbYKZTzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 14:55:51 -0500
Message-ID: <1527.92.50.109.198.1227729349.squirrel@webmail.madwifi.org> (sfid-20081126_205556_641305_2402EAA9)
In-Reply-To: <20081126171740.GB6515@tesla>
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla>
    <1227568883.28878.15.camel@dv>
    <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com>
    <492B623E.5030202@gmail.com> <1227580299.32415.2.camel@dv>
    <20081126001942.GN5950@tesla> <1227659754.2556.11.camel@dv>
    <20081126010218.GP5950@tesla>
    <1417.92.50.109.198.1227678824.squirrel@webmail.madwifi.org>
    <20081126171740.GB6515@tesla>
Date: Wed, 26 Nov 2008 20:55:49 +0100 (CET)
Subject: Re: wireless-regdb: flaw in general functionality
From: "Michael Renzmann" <mrenzmann@madwifi-project.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis Rodriguez" <luis.rodriguez@atheros.com>,
	"Pavel Roskin" <proski@gnu.org>,
	"Richard Farina" <sidhayn@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	"wireless" <linux-wireless@vger.kernel.org>,
	"Michael Green" <michael.green@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis.

Luis R. Rodriguez wrote:
>> Side note: this behaviour is not required in all jurisdictions. German
>> regulatory body for example allows use of non-DFS-compliant gear even on
>> (at least some) DFS channels, but only with low TX power. Is that
>> supported already?
> I reviewed this internally and there is disagreement on your statement
> about German rules.

Indeed, and that is for a good reason. I have rechecked, and I found that
I have confused TPC and DFS (doh!).

> For STA devices "DFS" is required for all Europe regdomains including
> Germany for channels 52 to 140 inclusive.

Ack.

Plus, if I understand the regulatory rules [1] correctly, channels 36 to
48 don't require DFS in Germany, but may only be used in confined spaces.
However, given that I was wrong with my understanding before, it would be
good if someone else could double-check.

Sorry for any caused confusion.

Bye, Mike

[1] http://www.bundesnetzagentur.de/media/archive/5009.pdf (german
language, )

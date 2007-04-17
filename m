Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-89.dex002.intermedia.net ([64.78.20.227]:5945 "EHLO
	dhost002-89.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031099AbXDQPzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 11:55:50 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Tue, 17 Apr 2007 08:41:46 -0700
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, Andreas Schwab <schwab@suse.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error loggingconditional on IEEE80211_DEBUG_DROP
Message-ID: <20070417154146.GA22909@devicescape.com>
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net> <jeirbwfb55.fsf@sykes.suse.de> <4623C561.4030201@lwfinger.net> <200704162237.01280.mb@bu3sch.de> <462413AE.9020200@lwfinger.net> <20070417131222.GA8633@tuxdriver.com> <1176819909.26202.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1176819909.26202.33.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2007 at 10:25:08AM -0400, Dan Williams wrote:

> What's the rationale for mac80211 _not_ using _GPL exports? I thought
> most new exports were pretty much required to be _GPL (otherwise
> somebody would NAK it) unless it was really, really necessary that they
> weren't.

Where is this kind of "requirement" documented? I was under the
impression that in general, the authors could decide how the symbols
gets exported as far as using _GPL or not is concerned.

My personal view on this _GPL in exports is that it is just unnecessary
extra complexity in the implementation and there should not be any place
for license enforcement in the kernel implementation; this is better
left for the license text and things completely outside the source code.
As such, I have a preference of not seeing _GPL added to code that is
derived from anything I've written.

-- 
Jouni Malinen                                            PGP id EFC895FA

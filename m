Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49596
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbXDQUmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 16:42:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error loggingconditional on IEEE80211_DEBUG_DROP
Date: Tue, 17 Apr 2007 22:40:43 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	Andreas Schwab <schwab@suse.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net> <1176819909.26202.33.camel@localhost.localdomain> <20070417154146.GA22909@devicescape.com>
In-Reply-To: <20070417154146.GA22909@devicescape.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704172240.43792.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 April 2007 17:41, Jouni Malinen wrote:
> My personal view on this _GPL in exports is that it is just unnecessary
> extra complexity in the implementation and there should not be any place
> for license enforcement in the kernel implementation; this is better
> left for the license text and things completely outside the source code.
> As such, I have a preference of not seeing _GPL added to code that is
> derived from anything I've written.

I clearly second that opinion and I thought we (the main people working
on wireless) had decided to _not_ use GPL syms in mac80211 (was d80211).
In my opinion license policy should not be represented in sourcecode.
Source is source, license is license. That are two absolutely seperate
things to me. For example, if I want to relicense some code (as
a copyright holder), I clearly don't want to change sourcecode for this.
In fact, I think the GPL suffix is pretty much useless, legal wise.
And everybody knows that the kernel is GPLed. So _every_ single symbol
is actually a _GPL() symbol. the _GPL() annotation is just redundant
and bloats code.

Using kernel syms from a non-GPL compatible module is always walking
a borderline. Be it for _GPL() or normal syms; Exactly the same issue
for both.

All IMO, of course. I'm perfectly aware of different people having
different opinions on this. ;)

-- 
Greetings Michael.

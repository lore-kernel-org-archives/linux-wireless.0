Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54507
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030572AbXBMARB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 19:17:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Date: Tue, 13 Feb 2007 01:16:50 +0100
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200702041344.19117.mb@bu3sch.de> <20070212235341.GD16597@instant802.com> <200702130106.37999.mb@bu3sch.de>
In-Reply-To: <200702130106.37999.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702130116.50406.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 February 2007 01:06, Michael Buesch wrote:
> On Tuesday 13 February 2007 00:53, Jouni Malinen wrote:
> > On Mon, Feb 12, 2007 at 10:39:31PM +0100, Michael Buesch wrote:
> > 
> > > What happens on RX when the iv32 wraps. Well, it simply won't decrypt
> > > the frame. What we must do then is upload a new key as fast as possible.
> > > The undecrypted frame can be either decrypted in SW (which I think d80211
> > > can do. At least with minor additional changes), or we drop it.
> > 
> > That "iv32 wrap" should have been "iv32 changes" (phase1 key changes
> 
> Yep, I'm sorry. It should be iv32, of course.

Ah, crap. I should really go to bed. ;)

-- 
Greetings Michael.

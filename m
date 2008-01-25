Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60199 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYAYSmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 13:42:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 19:41:25 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251921.48862.mb@bu3sch.de> <alpine.LFD.1.00.0801251032330.2979@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801251032330.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200801251941.25310.mb@bu3sch.de> (sfid-20080125_184255_311061_2C7D4C5E)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 19:34:46 Linus Torvalds wrote:
> My attitude is: CPU's that do unaligned accesses right are the *good* 
> CPU's. We should encourage them, and put the onus of being crap on the 
> ones that are crap, rather than penalizing the ones that aren't.

I absolutely agree. But as this can get fixed with _no_ performance loss
at all inside of the firmware (and who if not intel can change stuff
in their firmware?), I think this warning is in fact valid.

> In other words, we should use "get_unaligned()".

So we should put get_unaligned() into the whole networking stack below
wireless and penalize everybody, even gigabit-ethernet?

-- 
Greetings Michael.

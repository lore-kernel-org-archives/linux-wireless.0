Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:53141 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZGKVMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 17:12:00 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: cancel/restart all timers across suspend/resume
References: <1242391067.5799.53.camel@johannes.local>
	<1242553242.10005.76.camel@johannes.local> <m2hbxjky1q.fsf@igel.home>
	<1247334562.30647.111.camel@johannes.local> <m2ab3bkm2d.fsf@igel.home>
	<1247345548.30647.116.camel@johannes.local>
Date: Sat, 11 Jul 2009 23:11:57 +0200
In-Reply-To: <1247345548.30647.116.camel@johannes.local> (Johannes Berg's
	message of "Sat, 11 Jul 2009 22:52:28 +0200")
Message-ID: <m2y6qukjqa.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Odd, do you get console output before it hangs so you could add printks
> to figure out where? Jan said that just fixed it for him.

Just to clarify, the hanging resume is a different bug.  When applying
the patch on top of 5bb644a0f both suspend and resume work.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

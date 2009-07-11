Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:57749 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZGKQGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 12:06:09 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1MPf4T-0006yR-0I
	for linux-wireless@vger.kernel.org; Sat, 11 Jul 2009 18:05:05 +0200
From: Andreas Schwab <schwab@linux-m68k.org>
To: Johannes Berg
	<public-johannes-cdvu00un1VgdHxzADdlk8Q@hugh.gmane.org>
Cc: John Linville
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@hugh.gmane.org>,
	linux-wireless
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	"Luis R. Rodriguez"
	<public-mcgrof-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>
Subject: Re: [PATCH v2] mac80211: cancel/restart all timers across suspend/resume
References: <1242391067.5799.53.camel@johannes.local>
	<1242553242.10005.76.camel@johannes.local>
Date: Sat, 11 Jul 2009 18:02:41 +0200
In-Reply-To: <1242553242.10005.76.camel@johannes.local> (Johannes Berg's
	message of "Sun, 17 May 2009 11:40:42 +0200")
Message-ID: <m2hbxjky1q.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org> writes:

> We forgot to cancel all timers in mac80211 when suspending.
> In particular we forgot to deal with some things that can
> cause hardware reconfiguration -- while it is down.

This is breaking suspend on my iBook.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33509 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030777Ab3HITPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 15:15:12 -0400
Date: Fri, 9 Aug 2013 15:08:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-08-06
Message-ID: <20130809190833.GL30925@tuxdriver.com> (sfid-20130809_211518_648926_E700535E)
References: <1375779392.8219.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375779392.8219.9.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 06, 2013 at 10:56:32AM +0200, Johannes Berg wrote:
> Hi John,
> 
> And one more for mac80211-next (and I have nothing for mac80211 today).
> 
> Here I have an IBSS improvement, interworking (11u) definitions, a
> change to make the LED blinking nicer, more VHT (11ac) definitions, VHT
> radiotap TX status, channel switch support in cfg80211 and mac80211 as
> well as a small new debugfs file showing driver-buffered data for
> sleeping clients.
> 
> Let me know if there's any problem.
> 
> Thanks,
> johannes
> 
> The following changes since commit c82b5a74cc739385db6e4275fe504a0e9469bf01:
> 
>   mac80211: make active monitor injection work w/ HW queue (2013-07-16 09:58:19 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 73da7d5bab79ad7e16ff44d67c3fe8b9c0b33e5b:
> 
>   mac80211: add channel switch command and beacon callbacks (2013-08-01 18:30:33 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42908
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762098AbXGTRxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 13:53:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
Date: Fri, 20 Jul 2007 19:50:39 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <20070611103828.961999956@warmcat.com> <200707201936.41078.mb@bu3sch.de> <46A0F564.2090607@warmcat.com>
In-Reply-To: <46A0F564.2090607@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707201950.39353.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 July 2007 19:48:20 Andy Green wrote:
> Actually, I can't read dmesg on my In-laws' box that has the card the
> last few weeks: I read dmesg all the time if I suspect kernel-side
> trouble.  It's pretty simple and cheap to do a printk and give someone
> with problems the ability to dig themselves out of the trouble with a
> clue and even a URL in this case.
> 
> If the driver is dependent on a particular version of an external file,
> and you can read the version of that file at runtime, you really ought
> to be issuing a diagnostic if the dependency is violated.

Well, alternatively you can help to debug this bug, as this is the only
known bug regarding fw version.
You could get different versions and test them. So kind of bisecting
the actual change version.

-- 
Greetings Michael.

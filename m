Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:40960 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab1DAJyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 05:54:38 -0400
Date: Fri, 1 Apr 2011 12:54:28 +0300
From: Jouni Malinen <j@w1.fi>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ec15e68ba6a regresion?
Message-ID: <20110401095428.GA11779@jm.kir.nu>
References: <20110331154232.GA7370@redhat.com>
 <20110331154638.GA28649@jm.kir.nu>
 <20110401092506.GB2790@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110401092506.GB2790@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 01, 2011 at 11:25:08AM +0200, Stanislaw Gruszka wrote:

> Seems when disconnect event is handled, we remove some key. I'm
> attaching non-debug and debug logs. Note this is kinda old
> version of wpa_supplicant.

> wpa_driver_wext_disassociate

Huh.. This is with WEXT and the commit
ec15e68ba6a505631016f230899bafbb7b8cd0d6 is adding an nl80211 event. It
should have no change whatsoever to WEXT. I'm not sure whether I
understood the debug log correctly, so I'm not sure what was the area
that behaved incorrectly among multiple successful connections. Anyway,
I do not see how this particular commit could have anything to do with
this. Are you sure that this issues shows only when this commit is in
place and does not show if you revert just this commit?

-- 
Jouni Malinen                                            PGP id EFC895FA

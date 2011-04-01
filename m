Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab1DALLN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:11:13 -0400
Date: Fri, 1 Apr 2011 13:10:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ec15e68ba6a regresion?
Message-ID: <20110401111052.GC2790@redhat.com>
References: <20110331154232.GA7370@redhat.com>
 <20110331154638.GA28649@jm.kir.nu>
 <20110401092506.GB2790@redhat.com>
 <20110401095428.GA11779@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110401095428.GA11779@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 01, 2011 at 12:54:28PM +0300, Jouni Malinen wrote:
> On Fri, Apr 01, 2011 at 11:25:08AM +0200, Stanislaw Gruszka wrote:
> 
> > Seems when disconnect event is handled, we remove some key. I'm
> > attaching non-debug and debug logs. Note this is kinda old
> > version of wpa_supplicant.
> 
> > wpa_driver_wext_disassociate
> 
> Huh.. This is with WEXT and the commit
> ec15e68ba6a505631016f230899bafbb7b8cd0d6 is adding an nl80211 event. It
> should have no change whatsoever to WEXT. I'm not sure whether I
> understood the debug log correctly, so I'm not sure what was the area
> that behaved incorrectly among multiple successful connections. Anyway,
> I do not see how this particular commit could have anything to do with
> this. Are you sure that this issues shows only when this commit is in
> place and does not show if you revert just this commit?

I just reproduced the problem with commit reverted. Sorry for noise,
I'm going to investigate issue a bit more.

Stanislaw

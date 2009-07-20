Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4612 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZGTLxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 07:53:11 -0400
Date: Mon, 20 Jul 2009 07:52:44 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Using compat-wireless w/ 2.6.27.26
Message-ID: <20090720115244.GC9972@hash.localnet>
References: <4A612514.4050708@redfish-solutions.com> <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com> <4A635E04.4050204@redfish-solutions.com> <20090719203150.GA9972@hash.localnet> <4A63DF0B.4010801@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A63DF0B.4010801@redfish-solutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 19, 2009 at 08:05:47PM -0700, Philip A. Prindeville wrote:
> Actually, it's saying:
> 
> filename:       /lib/modules/2.6.27.26-astlinux/kernel/drivers/net/wireless/ath5k/ath5k.ko
> depends:        mac80211,cfg80211
> 
> And the 0.6.0 version number matches ath5k/base.c in the compat-wireless
> sources as well.

Yeah, ignore the module version number, no one ever changes it.

> Not seeing the dependency on "ath", which is strange.  Is that common code
> that's shared in 2.6.30 for the Atheros drivers?

In 2.6.31, yes.

> > The fix was merged after 2.6.30, IIRC, but it should definitely be in
> > compat-wireless.  Also check your modules directory for an old ath5k.ko
> > sitting in drivers/.../wireless/ath5k.  It should now be in ath/ath5k.

See above, the fix was post-2.6.30, however compat-wireless should have
it.  The module should now be in drivers/net/wireless/ath/ath5k, not
drivers/net/wireless/ath5k.

-- 
Bob Copeland %% www.bobcopeland.com


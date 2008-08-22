Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50977 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYHVPvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 11:51:13 -0400
Date: Fri, 22 Aug 2008 18:50:24 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Pending mac80211/ath9k patches
Message-ID: <20080822155024.GF4846@jm.kir.nu> (sfid-20080822_175122_663121_933C6945)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Number of the submitted, but not yet merged, mac80211 patches do not
apply in their original form to the current wireless-testing tree. In
order to make it easier to apply them, I made my updated quilt patches
available at http://w1.fi/wireless-testing/. I keep these synced with
the wireless-testing tree and the series file in that directory gives
some comments on the status (whether submitted for inclusion) of the
patches and it also gives a suggested order for applying the patches.
The patches that are not marked as submitted are for reference only and
not meant to be applied into wireless-testing at this point. Those are
mainly available for anyone who is interested in any of the areas I'm
working with (e.g., IEEE 802.11w, AP mode, and userspace client MLME).

I'm also including the pending ath9k patches in the same set. I noticed
that I forgot to add the '[PATCH]' prefix on the subject line for couple
of the patches, so if you are filtering messages based on that, you may
have missed these. Please let me know if you want them re-submitted.
Anyway, these patches are included with the rest of the files and are
commented as having been submitted for inclusion into the
wireless-testing in the series file.

-- 
Jouni Malinen                                            PGP id EFC895FA

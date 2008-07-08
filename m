Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:12107 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbYGHLpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 07:45:38 -0400
Received: by nf-out-0910.google.com with SMTP id d3so759504nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 04:45:36 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT 0/4] mac80211 improvements
Date: Tue, 8 Jul 2008 13:53:53 +0200
Cc: linux-wireless@vger.kernel.org
References: <20080705234735.210585000@sipsolutions.net>
In-Reply-To: <20080705234735.210585000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807081353.53559.IvDoorn@gmail.com> (sfid-20080708_134543_522806_3561B89D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 July 2008, Johannes Berg wrote:
> Here are a number of improvements for mac80211's virtual interface
> handling (master netdev, cleanups) and driver API (beaconing).
> 
> I have tested these patches on b43 in AP, STA and IBSS modes
> (communicating with my N810 or an AP) and have not seen any issues.
> 
> I would appreciate testing on other hardware (I can probably cover
> iwl4965, rt61pci and zd1211 next week), but I don't expect much
> trouble.

I have added these patches to rt2x00.git for testing purposes.

And to be more precise, the following patches have been added:

004-mac80211-master-not-ap.patch
005-mac80211-iface-cleanups.patch
006-mac80211-push-alive-check-down.patch
007-mac80211-beacon-revamp.patch
008-deprecate-sys-wireless.patch
009-local-bh-enable-consolidate.patch
010-linux-radiotap-rxflags.patch
011-allow-ap-vlan-modes.patch

Ivo

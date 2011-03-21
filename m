Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52387 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1CULX1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 07:23:27 -0400
To: Sean Robinson <seankrobinson@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: terminology questions
References: <AANLkTiniNj9vcYdSBpp+28zMDJEN-=hq40_1zxcrg74J@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 21 Mar 2011 13:23:22 +0200
In-Reply-To: <AANLkTiniNj9vcYdSBpp+28zMDJEN-=hq40_1zxcrg74J@mail.gmail.com> (Sean Robinson's message of "Sat\, 19 Mar 2011 09\:18\:07 -0700")
Message-ID: <87aagovhsl.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sean Robinson <seankrobinson@gmail.com> writes:

> What is a station?

You got an answer already. But in principle all devices supporting
IEEE 802.11 are stations (or STAs) in the standard.

> How does a station relate to an AP?

AP is a station as are all clients.

>  What are the delineations between mac80211/cfg80211/nl80211?

mac80211 is an IEEE 802.11 stack for softmac devices.

cfg80211 is a new (relatively speaking) component for managing
configuration of IEEE 802.11 devices (used by both mac80211 and
fullmac device drivers).

nl80211 is a new (again relatively speaking) netlink based user space
interface (protocol?) for managing IEEE 802.11 devices. cfg80211
implements the kernel side of this interface. From user space at least
wpasupplicant and iw use this interface, but in principle any
application can use it.

-- 
Kalle Valo

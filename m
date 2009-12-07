Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57918 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbZLGK7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 05:59:19 -0500
Received: by bwz27 with SMTP id 27so3364415bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 02:59:25 -0800 (PST)
To: 8an@praha12.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 2/4] mac80211: Add new callback set_coverage
References: <200912061820.26320.8an@praha12.net>
	<200912061823.45809.8an@praha12.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 07 Dec 2009 12:59:22 +0200
In-Reply-To: <200912061823.45809.8an@praha12.net> (=?iso-8859-15?Q?=22Luk?=
 =?iso-8859-15?Q?=E1=A8?= Turek"'s message of "Sun\, 6 Dec 2009 18\:23\:45
 +0100")
Message-ID: <87r5r73v91.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luká¨ Turek <8an@praha12.net> writes:

> Mac80211 callback to driver set_coverage() sets slot time and ACK timeout
> for given coverage class. The callback is optional, but it's essential for
> long distance links.

[...]

> + * @set_coverage: Set slot time for given coverage class as specified
> + *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
> + *	accordingly. Optional function, could be NULL.
> + *

Please document if the callback can sleep or not. Preferably the
former.

-- 
Kalle Valo

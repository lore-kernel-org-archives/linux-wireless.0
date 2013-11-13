Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KMVWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 16:22:24 -0500
Message-ID: <1384377738.28806.15.camel@jlt4.sipsolutions.net> (sfid-20131113_222226_477912_CFC7A179)
Subject: Re: [RFC 3/5] cfg80211: add regulatory quiescing support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 22:22:18 +0100
In-Reply-To: <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191310_064803_1FC4A1A3)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131113_191310_064803_1FC4A1A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> This quiesces devices when appropriate to ensure that
> regulatory domain updates take effect and avoid having
> devices initiate radiation when they should not.

I'm not really sure this makes sense.

If we're staying connected, how can we be moving far enough to go
through regulatory domains to have totally different rules?

(Also, probably best to squash patches 2 and 3, 2 is pointless by itself
and the code move is obvious with this patch)

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3JHMQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 08:16:14 -0400
Message-ID: <1381234564.13359.11.camel@jlt4.sipsolutions.net> (sfid-20131008_141622_904719_3A30B322)
Subject: Re: [PATCH] mac80211: port CCMP to cryptoapi's CCM driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Patch Tracking <patches@linaro.org>, linville@tuxdriver.com
Date: Tue, 08 Oct 2013 14:16:04 +0200
In-Reply-To: <CAKv+Gu9-ddqyuGg=NDFoWzNko+0uMG_po6WnzTc7g3DAzx=_dQ@mail.gmail.com> (sfid-20131008_140033_095639_86E4390E)
References: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1381233152.13359.10.camel@jlt4.sipsolutions.net>
	 <CAKv+Gu9-ddqyuGg=NDFoWzNko+0uMG_po6WnzTc7g3DAzx=_dQ@mail.gmail.com>
	 (sfid-20131008_140033_095639_86E4390E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-08 at 14:00 +0200, Ard Biesheuvel wrote:

> BTW I should probably have mentioned that this is fully tested code:
> my zd1211 works happily with it using pairwise CCMP with no
> regressions in performance.

Good to know. Not that I think zd1211 is a good device for performance
tests (you'd have to measure CPU utilisation in some way), but
ultimately it doesn't really matter as all the high-performance devices
need hardware crypto anyway.

johannes


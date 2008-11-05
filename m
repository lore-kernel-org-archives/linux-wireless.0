Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:31368 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYKEUQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:16:58 -0500
Received: by yw-out-2324.google.com with SMTP id 9so110798ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 12:16:57 -0800 (PST)
Message-ID: <43e72e890811051216w26acca38t6eb26081509bdf28@mail.gmail.com> (sfid-20081105_211701_152644_F74AC770)
Date: Wed, 5 Nov 2008 12:16:57 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: Re: [PATCH 0/7] cfg80211/mac80211: Add 802.11d support
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2008 at 6:49 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This patch series adds 802.11d support to mac80211 and
> cfg80211. I've tried to split the required changes as much
> as possible to make it easier for review. I've tested this
> on iwlagn with OLD_REG enabled and disable and with /sbin/crda
> missing and not. I'm sure I've missed a few corner cases, but
> I think this is a good start.

OK John here's the review, in case it helps

patch 1-5 are ACKed
patch 6 is unnecessary
I'll respin patch 7, and actually I'll split it in two to account for
the call_crda() return value thing.

  Luis

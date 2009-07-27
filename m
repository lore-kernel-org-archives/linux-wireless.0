Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:5754 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbZG0Pht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:37:49 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1661197qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 08:37:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248482853-17032-3-git-send-email-lrodriguez@atheros.com>
References: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
	<1248482853-17032-3-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 27 Jul 2009 08:37:29 -0700
Message-ID: <43e72e890907270837v152477f5x9dbd5d6aac25034c@mail.gmail.com>
Subject: Re: [PATCH] mac80211: do not queue work after suspend in the dynamic
	ps timer
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2009 at 5:47 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> This fixes this warning during suspend <--> resume:
>
> WARNING: at net/mac80211/util.c:511 ieee80211_queue_work+0x3a/0x40 [mac80211]()

Please ignore, I'll be sending this without depending on the other
patches, separately.

  Luis

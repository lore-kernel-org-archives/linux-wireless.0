Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3H3KEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 06:04:23 -0400
Message-ID: <1377857060.16256.2.camel@jlt4.sipsolutions.net> (sfid-20130830_120426_782910_1A49FE00)
Subject: Re: [PATCH v2] mac80211: change beacon/connection polling
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 12:04:20 +0200
In-Reply-To: <20130827093635.GD5548@redhat.com>
References: <20130823065200.GA3835@redhat.com>
	 <1377264280.14021.29.camel@jlt4.sipsolutions.net>
	 <20130827093635.GD5548@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-27 at 11:36 +0200, Stanislaw Gruszka wrote:
> Since when we detect baecon lost we do active AP probing (using nullfunc
> frame or probe request) there is no need to have beacon polling. Flags
> IEEE80211_STA_BEACON_POLL seems to be used just for historical reasons.
> 
> Change also make that after we start connection poll due to beacon loss,
> next received beacon will abort the poll.

Applied, thanks

johannes


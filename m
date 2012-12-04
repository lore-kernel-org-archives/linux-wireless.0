Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50853 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2LDTII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 14:08:08 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so3330345iay.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 11:08:08 -0800 (PST)
Date: Tue, 4 Dec 2012 14:07:30 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v2 14/18] regulatory: clarify locking rules and assertions
Message-ID: <20121204190730.GC29880@localhost> (sfid-20121204_200812_390521_3F7E1937)
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
 <1354632540-21207-15-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354632540-21207-15-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2012 at 03:48:56PM +0100, Johannes Berg wrote:
> Many places that currently check that cfg80211_
> The function needs to hold the cfg80211_mutex as
> it uses the global cfg80211_regdomain variable, so
> add the lock assertion to it and fix one of the
> callers that doesn't hold that mutex.

Something missing in the description there?

-- 
Bob Copeland %% www.bobcopeland.com

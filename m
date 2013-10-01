Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37435 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3JAWi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 18:38:27 -0400
Received: by mail-oa0-f45.google.com with SMTP id o17so6833oag.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 15:38:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380626514.14430.25.camel@jlt4.sipsolutions.net>
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	<1379115372-28426-2-git-send-email-yeohchunyeow@cozybit.com>
	<1380626514.14430.25.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 06:38:26 +0800
Message-ID: <CAHS2MGOd7TGyuHpnYkDR7d636nZqddmUJfvD6LRy_y=7QO7+xA@mail.gmail.com> (sfid-20131002_003830_673018_39CB7169)
Subject: Re: [PATCH 1/5] mac80211: process the CSA frame for mesh accordingly
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -ENOMEM ?
Yes.

> That's somewhat ugly, is there no better way to express that? Maybe with
> different structs or something? I guess I can live with it, just asking
> though.
It's uglier before Bob commenting on this. Hope that this works fine.

> No need for !! with bool variables
Noted.

Chun-Yeow

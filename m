Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43568 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab0LXEPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 23:15:52 -0500
Received: by qwa26 with SMTP id 26so6818292qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 20:15:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101222102032.13401.10967.stgit@localhost6.localdomain6>
References: <20101222102032.13401.10967.stgit@localhost6.localdomain6>
Date: Thu, 23 Dec 2010 23:15:50 -0500
Message-ID: <AANLkTik-gp3CXhM1tR5obgkuMyLBkzDvZA5UVSJGEsu-@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Move mac80211 functions into new file
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 5:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> Move mac80211 functions into new file mac80211-ops.c to have a better
> separation and to make base.c smaller.

Or we could move the non-ops to a different file...

BTW I just rebased my sta PS code and I'll be working on it this
holiday week.. I guess I'll re-rebase it whenever I get it
working.

-- 
Bob Copeland %% www.bobcopeland.com

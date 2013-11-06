Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:52698 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab3KFPOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 10:14:24 -0500
Received: by mail-bk0-f53.google.com with SMTP id w11so3498885bkz.40
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 07:14:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383734156.14307.24.camel@jlt4.sipsolutions.net>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com> <1383734156.14307.24.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 6 Nov 2013 07:14:03 -0800
Message-ID: <CAG6hwVOi87-oHOOCT69wZR93+Y36NJzwReSGE0WnR-Q5TTPDaA@mail.gmail.com> (sfid-20131106_161427_931558_B4E54D6B)
Subject: Re: [PATCH 01/17] mac80211: fix off-by-one in llid check.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 6, 2013 at 2:35 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Very nice. I've squashed the llid assignment into the patch that
> introduced the warning.

Hm, ok. Guess you can't get them all :)

Thanks!

-- 
Thomas

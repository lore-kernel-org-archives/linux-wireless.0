Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39287 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2LFXsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 18:48:02 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so11898lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 15:48:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-3-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-3-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 15:47:40 -0800
Message-ID: <CAB=NE6XWKoRODSOcmgxhENmC3ZkOO5qCE-RBHwaMA-vusz+Dqw@mail.gmail.com> (sfid-20121207_004807_184487_68069CC5)
Subject: Re: [PATCH 02/24] regulatory: don't allocate too much memory
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There's no need to allocate one reg rule more
> than will be used, reduce the allocations. The
> allocation in nl80211 already doesn't allocate
> too much space.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Just for the record without this I ran into odd issues that I could
not root cause but glad you have verified this should be a non-issue.
I'll ACK-it provided we let it rip and find any issues during in the
development cycle.

  Luis

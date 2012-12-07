Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:37664 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423000Ab2LGAze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:55:34 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5754197lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:55:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-15-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-15-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:55:12 -0800
Message-ID: <CAB=NE6V+2TY95PgNRStm7jq2498b37qq16v=zxvO+USGBWsGVg@mail.gmail.com> (sfid-20121207_020935_208027_A5947F15)
Subject: Re: [PATCH 14/24] regulatory: remove useless warning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Even if it never happens and is hidden behind the
> debug config option, it's completely useless: the
> calltrace will only show module loading.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis

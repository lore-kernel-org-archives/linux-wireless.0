Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51438 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160996Ab2LGALN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:11:13 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5739102lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:11:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-7-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-7-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:10:51 -0800
Message-ID: <CAB=NE6VPDosrNAKGLhv0juLiPTi7C9rSGku7xDtSBXF0hrc2PQ@mail.gmail.com> (sfid-20121207_011118_373084_23C531C0)
Subject: Re: [PATCH 06/24] regulatory: simplify regulatory_hint_11d
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There's no need to unlock before calling
> queue_regulatory_request(), so simplify
> the function.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Sure, I was just trying to be consistent with the rest of the context
of the other queue_regulatory_request() calls. Either way.

  Luis

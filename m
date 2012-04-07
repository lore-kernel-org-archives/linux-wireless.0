Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48024 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2DGCXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 22:23:54 -0400
Received: by iagz16 with SMTP id z16so3783788iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 19:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333746034.5577.10.camel@jlt3.sipsolutions.net>
References: <1333746034.5577.10.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Apr 2012 19:23:33 -0700
Message-ID: <CAB=NE6XMuaAPFPfKGunrGuqnYLKfem35Q3nXiEpc7u23FM14ng@mail.gmail.com> (sfid-20120407_042429_824592_0256491A)
Subject: Re: [PATCH] compat: backport netif_wake_subqueue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 6, 2012 at 2:00 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Kernels 2.6.23 - 2.6.27 had some multiqueue support,
> but called netif_wake_subqueue netif_start_subqueue.
> So to backport, just add a define.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed, and tested with ckmake, thanks!

  Luis

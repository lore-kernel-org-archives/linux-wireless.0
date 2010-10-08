Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55292 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab0JHUt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 16:49:26 -0400
Received: by fxm14 with SMTP id 14so736806fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 13:49:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v2] mac80211: temporarily disable reorder release timer
Date: Fri, 8 Oct 2010 22:49:20 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <201010082235.09355.chunkeey@googlemail.com> <AANLkTi=LxUqST506VGiM8RpEZXrJ6_EWVRiJHboGVv5i@mail.gmail.com>
In-Reply-To: <AANLkTi=LxUqST506VGiM8RpEZXrJ6_EWVRiJHboGVv5i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010082249.20545.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 October 2010 22:40:39 Luis R. Rodriguez wrote:
> On Fri, Oct 8, 2010 at 1:35 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > Several serve threading problems in the current
> > release reorder timer implementation have been
> > discovered.
> >
> > A lengthy discussion - which lists some of the
> > pitfalls and possible solutions - can be found at:
> >  http://marc.info/?t=128635927000001
> >
> > But due to the complicated nature of the subject and
> > the imminent advent of a new -rc cycle, it was
> > decided to disable the feature for the time being.
> >
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> 
> This patch lacks documentation of the impact of this patch, while it
> may fix a lock issue, the does not address what happens when the patch
> is actually applied.
? It just disables the timer. The actual reorder code
is left untouched, everything is the same as in Linus'
2.6.36-rcX tree.

Or what impact are you talking about?

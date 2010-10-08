Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39242 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab0JHUlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 16:41:00 -0400
Received: by gwj17 with SMTP id 17so455248gwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 13:40:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010082235.09355.chunkeey@googlemail.com>
References: <201010082235.09355.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 8 Oct 2010 13:40:39 -0700
Message-ID: <AANLkTi=LxUqST506VGiM8RpEZXrJ6_EWVRiJHboGVv5i@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: temporarily disable reorder release timer
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 8, 2010 at 1:35 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Several serve threading problems in the current
> release reorder timer implementation have been
> discovered.
>
> A lengthy discussion - which lists some of the
> pitfalls and possible solutions - can be found at:
>  http://marc.info/?t=128635927000001
>
> But due to the complicated nature of the subject and
> the imminent advent of a new -rc cycle, it was
> decided to disable the feature for the time being.
>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

This patch lacks documentation of the impact of this patch, while it
may fix a lock issue, the does not address what happens when the patch
is actually applied.

  Luis

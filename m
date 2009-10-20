Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:35390 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZJTGZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 02:25:15 -0400
Received: by iwn8 with SMTP id 8so2729934iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 23:25:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256018933.4475.6.camel@johannes.local>
References: <1256018933.4475.6.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 20 Oct 2009 15:24:59 +0900
Message-ID: <43e72e890910192324t3deab484nad855a5ecd109dd@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: sme: deauthenticate on assoc failure
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2009 at 3:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> When the in-kernel SME gets an association failure from
> the AP we don't deauthenticate, and thus get into a very
> confused state which will lead to warnings later on. Fix
> this by actually deauthenticating when the AP indicates
> an association failure.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks Johannes.

Tested-by: Luis R. Rodriguez <lrodriguez@atheros.com>

John -- this patch and the previous patch titled "mac80211: keep auth
state when assoc fails" fix the SME warning as well. These are also
2.6.32-rc fixes.

  Luis

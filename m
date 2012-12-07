Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41688 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2LGAC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:02:27 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so18082lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:02:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-6-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-6-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:02:05 -0800
Message-ID: <CAB=NE6Xea8PWs+cSRe39zL5g8U2RUt8g7fbVHmrM+1MYM9286Q@mail.gmail.com> (sfid-20121207_010229_890848_495E7656)
Subject: Re: [PATCH 05/24] regulatory: don't test list before iterating
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There's no need to test whether a list is
> empty or not before iterating.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

I had also ran into issues without the checks, but glad you have
verified things are kosher.

  Luis

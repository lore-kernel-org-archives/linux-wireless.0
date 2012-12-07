Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40744 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2LGAyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:54:50 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so35507lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:54:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-14-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-14-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:54:28 -0800
Message-ID: <CAB=NE6XFdBxqZg4TC7TUA1PK7SgHemrZjp2aJP0gD9LRH_O=TQ@mail.gmail.com> (sfid-20121207_015506_459520_EBEDD41F)
Subject: Re: [PATCH 13/24] regulatory: remove redundant isalpha() check
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> toupper() only modifies lower-case letters, so
> the isalpha() check is redundant; remove it.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:37438 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422674Ab2LGAUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:20:39 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5742122lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:20:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-10-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-10-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:20:17 -0800
Message-ID: <CAB=NE6UY6Y7c=sTAoMasY5bgc-q5LfrbT-Tg3xXwtJdtnvU=MQ@mail.gmail.com> (sfid-20121207_012045_650189_1E4D6AE3)
Subject: Re: [PATCH 09/24] regulatory: use proper enum for return values
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Instead of treating special error codes specially,
> like -EALREADY, introduce a real enum for all the
> needed possibilities and use it.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis

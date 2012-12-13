Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61661 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2LMWKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:10:40 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2245691lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:10:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-25-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-25-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:10:18 -0800
Message-ID: <CAB=NE6XeAzcXjigUchWV7SeAcfU7m1LDaoQoQH_KddQGFbvxuQ@mail.gmail.com> (sfid-20121213_231044_701281_FF8526C3)
Subject: Re: [PATCH 24/24] regulatory: use IS_ERR macro family for freq_reg_info
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Instead of returning an error and filling a pointer
> return the pointer and an ERR_PTR value in error cases.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis

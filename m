Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:59171 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaBSAbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 19:31:39 -0500
Received: by mail-la0-f46.google.com with SMTP id b8so12808083lan.33
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 16:31:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 16:31:18 -0800
Message-ID: <CAB=NE6XXxW4dtP9=xsL_vjiA1kKbRvb3SheVdyrx8jXJXgxU+A@mail.gmail.com> (sfid-20140219_013143_184364_7CBBCCA7)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 10:54 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Introduce DFS CAC time as a regd param, configured
> per REG_RULE and set per channel in cfg80211.
> DFS CAC time is close connected with regulatory
> database configuration. Instead of using hardcoded
> values, get DFS CAC time form regulatory database.
> Pass DFS CAC time to user mode (mainly for iw reg get,
> iw list, iw info). Allow setting DFS CAC time via CRDA.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Please also send a respective patch follow up (v2) that also addresses
the intersection of the cac time on the userspace equivalent of the
intersection.

  Luis

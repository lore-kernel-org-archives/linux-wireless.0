Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45396 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2GDQ0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 12:26:39 -0400
Received: by yhmm54 with SMTP id m54so7405992yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 09:26:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341394944.4482.9.camel@jlt3.sipsolutions.net>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com> <1341394944.4482.9.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 4 Jul 2012 09:26:18 -0700
Message-ID: <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com> (sfid-20120704_182643_661391_2901327E)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've skipped the other comments as I can address those in a new series.

On Wed, Jul 4, 2012 at 2:42 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> So I'm not really convinced about this. It seems this Kconfig should
> better be a Kconfig that enables other Kconfig only, not enabling other
> features. How else would anyone be able to do due diligence and check
> what exactly this enables that they need to test?

Makes sense, so would we then have CONFIG_REG_HINT_CELL_BASE_STATION ?

  Luis

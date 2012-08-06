Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41777 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab2HFTyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:54:05 -0400
Received: by yenl2 with SMTP id l2so2928034yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:54:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344162581.4513.1.camel@jlt3.sipsolutions.net>
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net> <1344162581.4513.1.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 12:53:44 -0700
Message-ID: <CAB=NE6XLMTwG65EhExSES-rPsKK7SDBx4+MgwqxuJL__ZtN=zw@mail.gmail.com> (sfid-20120806_215411_866981_15CD4590)
Subject: Re: [PATCH v2] compat: deal with backported codel
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 5, 2012 at 3:29 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Some distro kernels (in particular the Debian 3.2.0-3
> kernel I'm running) backport codel already, so trying
> to backport it again causes issues. Protect the compat
> backport with #ifdef TCA_CODEL_MAX.
>
> Also link the flow_dissector code into the codel module
> which then won't be loaded on kernels that already have
> codel backported.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed, thanks!

  Luis

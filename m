Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36740 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcCCPli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:41:38 -0500
Received: by mail-wm0-f66.google.com with SMTP id l68so4726331wml.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 07:41:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457019637.2044.26.camel@sipsolutions.net>
References: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
 <1456954113-4682-3-git-send-email-emmanuel.grumbach@intel.com> <1457019637.2044.26.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 3 Mar 2016 17:41:22 +0200
Message-ID: <CA+XVXfcYSJRcQZrY7qXok__+T-+AxBwQS8c9FqQH_Ata-OGXVA@mail.gmail.com> (sfid-20160303_164141_526191_4E6690EA)
Subject: Re: [PATCH 3/3] mac80211: recalc min_def chanctx even when chandef is identical
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 3, 2016 at 5:40 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> All three applied, but I had to fix your Fixes tag commit ID, no idea
> what that referred to :)

Yea I might have taken it from some internal tree :)

Arik

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f48.google.com ([209.85.161.48]:45842 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbeHVS5f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 14:57:35 -0400
Date: Wed, 22 Aug 2018 08:32:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Byungchul Park <byungchul.park@lge.com>
Subject: Re: [PATCH v2 0/2] workqueue lockdep limitations/bugs
Message-ID: <20180822153210.GV3978217@devbig004.ftw2.facebook.com> (sfid-20180822_173221_430610_E555FE1C)
References: <20180822094904.15718-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180822094904.15718-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2018 at 11:49:02AM +0200, Johannes Berg wrote:
> This addresses the first two issues.
> 
> The third problem is actually caught when the flush ever does
> anything, but that might be rare depending on the circumstances,
> so I still think it'd be nice to catch it somehow, but right now
> I don't have the time to look into it.

Applied to libata/for-4.19.

Thanks.

-- 
tejun

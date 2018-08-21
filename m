Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:35530 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeHUUk4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 16:40:56 -0400
Message-ID: <1534871989.25523.36.camel@sipsolutions.net> (sfid-20180821_192025_803478_78998022)
Subject: Re: [PATCH 2/2] workqueue: create lockdep dependency in flush_work()
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 19:19:49 +0200
In-Reply-To: <20180821160914.GQ3978217@devbig004.ftw2.facebook.com> (sfid-20180821_180918_893691_208AE1E0)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
         <20180821120317.4115-3-johannes@sipsolutions.net>
         <20180821160914.GQ3978217@devbig004.ftw2.facebook.com>
         (sfid-20180821_180918_893691_208AE1E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 09:09 -0700, Tejun Heo wrote:
> 
> This makes sense to me.  Did you notice any extra lockdep warnings
> with this?

I haven't used it beyond testing the trivial example I created on the
spot with a small mac80211 change, so can't really say either way.

johannes

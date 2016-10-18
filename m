Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54447 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752586AbcJRGv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 02:51:56 -0400
Message-ID: <1476773507.6425.0.camel@sipsolutions.net> (sfid-20161018_085159_487356_19EE1BAE)
Subject: Re: [PATCH -next] cfg80211: fix possible memory leak in
 cfg80211_iter_combinations()
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 18 Oct 2016 08:51:47 +0200
In-Reply-To: <1476717916-23302-1-git-send-email-weiyj.lk@gmail.com> (sfid-20161017_172536_647310_DF0D8F74)
References: <1476717916-23302-1-git-send-email-weiyj.lk@gmail.com>
         (sfid-20161017_172536_647310_DF0D8F74)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-17 at 15:25 +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> 'limits' is malloced in cfg80211_iter_combinations() and should be
> freed
> before leaving from the error handling cases, otherwise it will cause
> memory leak.

Yep, thanks; applied.

johannes

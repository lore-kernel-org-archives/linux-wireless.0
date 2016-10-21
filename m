Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59838 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754795AbcJUKY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 06:24:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <johannes@sipsolutions.net>)
        id 1bxWzz-0001k1-M3
        for linux-wireless@vger.kernel.org; Fri, 21 Oct 2016 12:24:27 +0200
Message-ID: <1477045466.4068.29.camel@sipsolutions.net> (sfid-20161021_122432_479853_22095C10)
Subject: Re: [PATCH] cfg80211: don't export cfg80211_iter_combinations()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 21 Oct 2016 12:24:26 +0200
In-Reply-To: <1477045188-13733-1-git-send-email-johannes@sipsolutions.net> (sfid-20161021_121956_012094_24E20B00)
References: <1477045188-13733-1-git-send-email-johannes@sipsolutions.net>
         (sfid-20161021_121956_012094_24E20B00)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-21 at 12:19 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Nothing uses it outside of cfg80211, and since only
> cfg80211_check_combinations() uses it in the same file
> it can even be static - do that.
> 
Err, obviously my git grep foo failed me ... :)

johannes

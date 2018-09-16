Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18597 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbeIPPfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 11:35:17 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Pavel Machek <pavel@ucw.cz>,
        Johannes Berg <johannes@sipsolutions.net>
CC: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Subject: RE: [linuxwifi] [PATCH] fix iwlwifi on old cards in v4.19 was Re:
 4.19-rc[23] iwlwifi: BUG in swiotlb
Date: Sun, 16 Sep 2018 10:12:48 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301336B20F4@HASMSX111.ger.corp.intel.com> (sfid-20180916_121328_270333_C6842397)
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net> <20180916093414.GA4299@amd>
 <20180916094142.GB4299@amd> <20180916095535.GA4245@amd>
 <20180916095935.GA4388@amd>
In-Reply-To: <20180916095935.GA4388@amd>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> 
> .max_tfd_queue_size was ommited for old cards, leading to oops in swiotlb.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 

I picked it up in our tree with minor commit message fixes.
I also added the Fixes tag for stable.

Thanks!

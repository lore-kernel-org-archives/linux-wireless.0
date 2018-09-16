Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58837 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbeIPPhP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 11:37:15 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Johannes Berg <johannes@sipsolutions.net>
CC: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Subject: RE: [linuxwifi] [PATCH] fix iwlwifi on old cards in v4.19 was Re:
 4.19-rc[23] iwlwifi: BUG in swiotlb
Date: Sun, 16 Sep 2018 10:14:22 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301336B2111@HASMSX111.ger.corp.intel.com> (sfid-20180916_121505_432109_535F1E00)
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net> <20180916093414.GA4299@amd>
 <20180916094142.GB4299@amd> <20180916095535.GA4245@amd>
 <20180916095935.GA4388@amd>
 <0BA3FCBA62E2DC44AF3030971E174FB301336B20F4@HASMSX111.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301336B20F4@HASMSX111.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> >
> >
> > .max_tfd_queue_size was ommited for old cards, leading to oops in
> swiotlb.
> >
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >
> 
> I picked it up in our tree with minor commit message fixes.
> I also added the Fixes tag for stable.
> 

Ah, of course... not needed... Sorry...

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34124 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdDLOBh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 10:01:37 -0400
Received: by mail-wm0-f66.google.com with SMTP id x75so6604728wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 07:01:36 -0700 (PDT)
Date: Wed, 12 Apr 2017 16:01:34 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next v5 2/5] genetlink: pass extended ACK report down
Message-ID: <20170412140134.GI1952@nanopsycho> (sfid-20170412_160147_648397_3E4F1A2B)
References: <20170412123408.22012-1-johannes@sipsolutions.net>
 <20170412123408.22012-3-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170412123408.22012-3-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Apr 12, 2017 at 02:34:05PM CEST, johannes@sipsolutions.net wrote:
>From: Johannes Berg <johannes.berg@intel.com>
>
>Pass the extended ACK reporting struct down from generic
>netlink to the families, using the existing struct
>genl_info for simplicity.
>
>Also add support to set the extended ACK information from
>generic netlink users.
>
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>---

Aside from the tinyfication of desc lines, this looks good to me

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

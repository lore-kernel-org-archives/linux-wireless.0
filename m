Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44728 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757047AbdJKIHS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:07:18 -0400
Message-ID: <1507709235.1998.17.camel@sipsolutions.net> (sfid-20171011_100844_724095_8447CA1A)
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com,
        Johannes Berg <johannes.berg@intel.com>
Date: Wed, 11 Oct 2017 10:07:15 +0200
In-Reply-To: <1507708948.1998.15.camel@sipsolutions.net>
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
         (sfid-20171010_225427_620459_2849A16B) <1507708948.1998.15.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-11 at 10:02 +0200, Johannes Berg wrote:

> Overall, this isn't very well defined for AP mode...

No, that's not really correct. It *is* well defined (set the rate for
all clients to the same fixed rate), but that definition isn't very
good because if that rate isn't a basic rate, clients can connect that
don't support this rate...

johannes

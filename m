Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54376 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932657AbdIFPLy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 11:11:54 -0400
Message-ID: <1504710711.23905.17.camel@sipsolutions.net> (sfid-20170906_171229_484861_A4392420)
Subject: Re: hung task in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <mcroce@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Sep 2017 17:11:51 +0200
In-Reply-To: <CAGnkfhyBMKT-Tf10NxjN40Znuj7OK2pSM3qLUidPSkQqh8gjwQ@mail.gmail.com> (sfid-20170906_170509_159201_9F9A1278)
References: <CAGnkfhwi9MmtLneeU23iWEGLj9cb1ODb3KzzOqTDvA6nNVsugg@mail.gmail.com>
         <1504702728.13457.17.camel@sipsolutions.net>
         <CAGnkfhyBMKT-Tf10NxjN40Znuj7OK2pSM3qLUidPSkQqh8gjwQ@mail.gmail.com>
         (sfid-20170906_170509_159201_9F9A1278)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-09-06 at 17:04 +0200, Matteo Croce wrote:
> 
> I confirm that this patch fixes the hang too.

Cool, I'll go apply it.

> I'm curious to see if there are noticeable performance differences
> between the two solutions.

Nope, you hit this code path essentially once.

johannes

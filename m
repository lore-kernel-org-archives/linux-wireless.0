Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40304 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752565AbdFUIgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 04:36:19 -0400
Message-ID: <1498034176.4955.2.camel@sipsolutions.net> (sfid-20170621_103641_980642_38363762)
Subject: Re: [RFC] mac80211: support non-data TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Jun 2017 10:36:16 +0200
In-Reply-To: <b4a28e42-bc8c-57ff-0bc0-e0b1eed6a6c1@quantenna.com>
References: <20170620210309.1193-1-johannes@sipsolutions.net>
         <c8637109-0292-23af-8bc6-8a7ba8e19595@quantenna.com>
         <1498028959.4955.1.camel@sipsolutions.net>
         <b4a28e42-bc8c-57ff-0bc0-e0b1eed6a6c1@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 00:38 -0700, Igor Mitsyanko wrote:
> 
> > That's standard for management frames, I really didn't think that'd
> > need any comment?
> 
> You're right, for some reason I thought about "null data" frames
> instead of "no data" frames.

Well, the next patch actually does put those there as well :)

johannes

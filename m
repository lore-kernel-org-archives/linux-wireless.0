Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58232 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753295AbeAaWBA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 17:01:00 -0500
Message-ID: <1517436058.28814.5.camel@sipsolutions.net> (sfid-20180131_230103_639826_E3A3701C)
Subject: Re: [PATCH 5/6] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 31 Jan 2018 23:00:58 +0100
In-Reply-To: <e8e2aeba-edd3-30f6-3960-0578ae127336@gmail.com> (sfid-20180131_225807_098372_0F471554)
References: <20180131213329.25322-1-denkenz@gmail.com>
         <20180131213329.25322-6-denkenz@gmail.com>
         <1517435621.2189.67.camel@sipsolutions.net>
         <e8e2aeba-edd3-30f6-3960-0578ae127336@gmail.com>
         (sfid-20180131_225807_098372_0F471554)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-31 at 15:58 -0600, Denis Kenzior wrote:

> > Actually, then again, that's awkward because doing events and commands
> > on the same socket doesn't mix all _that_ well. Perhaps we just need to
> > fix that problem in libnl or something and be done with it ...
> > 
> 
> There are no issues on our side..

I guess you don't use libnl then :-) It doesn't exactly make it easy to
receive events while waiting for an ACK.

johannes

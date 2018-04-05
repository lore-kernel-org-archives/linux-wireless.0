Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40556 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeDEIfM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 04:35:12 -0400
Message-ID: <1522917309.7140.2.camel@sipsolutions.net> (sfid-20180405_103517_611852_8FA8715D)
Subject: Re: PATCH [1/1]: wireless: mac80211_hwsim: support/ignore power
 state changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Roman Kiryanov <rkir@google.com>, linux-wireless@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@google.com>,
        Bjoern Johansson <bjoernj@google.com>, Bo Hu <bohu@google.com>
Date: Thu, 05 Apr 2018 10:35:09 +0200
In-Reply-To: <CAOGAQep2Yj62JDAY0qGwXFYohsje6fuu57Ss4U7+coygBe7u0A@mail.gmail.com> (sfid-20180405_103356_996185_AA6D2B3C)
References: <CAOGAQep2Yj62JDAY0qGwXFYohsje6fuu57Ss4U7+coygBe7u0A@mail.gmail.com>
         (sfid-20180405_103356_996185_AA6D2B3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> indicate power state support. This in turn causes VTS failures because
> the WiFi HAL can't enable power saving mode. The remaining code is
> just there to deal with the incoming state change request.

What's VTS?

johannes

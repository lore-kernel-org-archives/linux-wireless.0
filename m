Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42314 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754544AbdC2IYK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:24:10 -0400
Message-ID: <1490775841.7948.5.camel@sipsolutions.net> (sfid-20170329_102506_664872_496E4437)
Subject: Re: [PATCH v2] mac80211: mesh - always do every discovery retry
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Jesse Jones <jjones@uniumwifi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Date: Wed, 29 Mar 2017 10:24:01 +0200
In-Reply-To: <CAEFj984B=6C_AvzHqKnLLS5-h3cKMDmasXANQF1UZT64JSfW8g@mail.gmail.com> (sfid-20170307_040923_027768_9F7300BC)
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
         <b285e11810b612a6a156693f34e232ac@mail.gmail.com>
         <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
         <39c846a5bcfa1fff26f69a082466e414@mail.gmail.com>
         <CAEFj987m=5a6pWZLMtTcVshmVfOmwwbb-+s0FR_+Dz6_xx7Dtw@mail.gmail.com>
         <CAEFj9868zDVomdjQhrzNKs9ANaRF85wdA49vKwVZJ2dUiTpoVg@mail.gmail.com>
         <faafc817ee74ba39171199985756b87b@mail.gmail.com>
         <CAEFj984B=6C_AvzHqKnLLS5-h3cKMDmasXANQF1UZT64JSfW8g@mail.gmail.com>
         (sfid-20170307_040923_027768_9F7300BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's the outcome of this? I'm tempted to apply the patch since it's
optional anyway ...

johannes

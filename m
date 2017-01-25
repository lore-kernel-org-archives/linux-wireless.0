Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34538 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751432AbdAYJRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 04:17:47 -0500
Message-ID: <1485335859.17709.3.camel@sipsolutions.net> (sfid-20170125_101808_371460_871013C0)
Subject: Re: [PATCH 2/2] mac80211: use accessor functions to set sta->_flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Amadeusz Slawinski <amadeusz.slawinski@tieto.com>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jan 2017 10:17:39 +0100
In-Reply-To: <CA+db6Z1OtO4_93KN-YoEaVg79zY5BgX2u0S+8FGVdkWav0iB2g@mail.gmail.com> (sfid-20170125_095558_832079_04D76103)
References: <1485272531-11587-1-git-send-email-amadeusz.slawinski@tieto.com>
         <1485272531-11587-2-git-send-email-amadeusz.slawinski@tieto.com>
         <1485272668.1236.5.camel@sipsolutions.net>
         <CA+db6Z1OtO4_93KN-YoEaVg79zY5BgX2u0S+8FGVdkWav0iB2g@mail.gmail.com>
         (sfid-20170125_095558_832079_04D76103)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-25 at 09:55 +0100, Amadeusz Slawinski wrote:
> And yes I did. Somehow managed to ignore those warnings though, sorry
> about that.

:)
That was intentional so nobody changing mac80211 in the future will
accidentally play with those flags through the normal accessors.

> Rechecked with just first patch and it should still be good. Please
> ignore this one ;)

Yeah, I still have that one pending, no worries :)

johannes

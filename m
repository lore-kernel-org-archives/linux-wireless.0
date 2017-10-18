Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55038 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753817AbdJRLbf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 07:31:35 -0400
Message-ID: <1508326291.2674.21.camel@sipsolutions.net> (sfid-20171018_133153_823764_C25288EB)
Subject: Re: [PATCH] mac80211: aggregation: Convert timers to use
 timer_setup()
From: Johannes Berg <johannes@sipsolutions.net>
To: Kees Cook <keescook@chromium.org>, linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Oct 2017 13:31:31 +0200
In-Reply-To: <1508322566.2674.17.camel@sipsolutions.net> (sfid-20171018_122945_123971_5A96CA64)
References: <20171017202545.GA115810@beast>
         (sfid-20171017_222550_315925_34B26DDB) <1508322566.2674.17.camel@sipsolutions.net>
         (sfid-20171018_122945_123971_5A96CA64)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-18 at 12:29 +0200, Johannes Berg wrote:

> Anyway, the change here looks correct to me, so I'll apply it and then
> perhaps clean up more. I've only changed "u16 tid" to "u8 tid" since
> the valid range is 0-15 (in theory, in practice 0-7).

Well, I guess I'm clearly wrong - it's crashing our test suite left and
right.

I'll dig a little bit, but I don't have much time today, and will be
out for a few days starting tomorrow.

johannes

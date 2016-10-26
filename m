Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37653 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbcJZDZx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 23:25:53 -0400
Received: by mail-it0-f49.google.com with SMTP id u205so7186882itc.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2016 20:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1477379678.4390.2.camel@sipsolutions.net>
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
 <1477286912.4085.1.camel@sipsolutions.net> <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com>
 <1477379678.4390.2.camel@sipsolutions.net>
From: Adrian Chadd <adrian@freebsd.org>
Date: Tue, 25 Oct 2016 20:25:52 -0700
Message-ID: <CAJ-Vmon0RTAXJMuwANCO23cPsFyFZ17sAHoReuGBG1u1Q9kK6w@mail.gmail.com> (sfid-20161026_052558_538566_F3ABBA40)
Subject: Re: Bayesian rate control
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjornsmedman@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hiya,

there's a tplink RTL81xx 11ac NIC that's growing linux and freebsd
support. I believe it's software rate controllable.

The intel 7260 and later parts also allow user controllable rate
control and provide transmit completion feedback, but I don't know
whether it's enough for your needs.

Unfortunately the ath10k firmware .. doesn't :( Not by default, anyway.


-adrian

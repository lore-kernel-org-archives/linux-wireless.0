Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:56130 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753835AbeBSUlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 15:41:05 -0500
Message-ID: <1519072860.16723.22.camel@sipsolutions.net> (sfid-20180219_214124_451574_E10FA16D)
Subject: Re: WARNING in check_flush_dependency
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+41cdaf4232c50e658934@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Date: Mon, 19 Feb 2018 21:41:00 +0100
In-Reply-To: <CACT4Y+bziyU+32umG=VD7wCbxpsKoGkbAypDwQS=PivfGSzypA@mail.gmail.com> (sfid-20180219_195836_294501_B226CD07)
References: <001a1143c56ef80bb405636ca341@google.com>
         <1516779566.2508.41.camel@sipsolutions.net>
         <CACT4Y+bziyU+32umG=VD7wCbxpsKoGkbAypDwQS=PivfGSzypA@mail.gmail.com>
         (sfid-20180219_195836_294501_B226CD07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 19:58 +0100, Dmitry Vyukov wrote:
> 
> > Yeah, we clearly shouldn't have WQ_RECLAIM set on this workqueue...
> 
> Hi Johannes,
> 
> Do you mind to send a patch to fix this?

Yeah, sorry, I've been behind on patches a bit. I just applied it
today, and once I've let it sit for a day for build bot etc. I'll send
it up.

Let me double-check I've added the syzbot annotation to it though ...

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f51.google.com ([209.85.160.51]:44044 "EHLO
        mail-pl0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754037AbeDBB6F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Apr 2018 21:58:05 -0400
Date: Mon, 2 Apr 2018 10:57:59 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+19c436b56eaa98e50e98@syzkaller.appspotmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: INFO: rcu detected stall in vprintk_default
Message-ID: <20180402015759.GC3795@jagdpanzerIV> (sfid-20180402_035820_770998_50C8381D)
References: <000000000000cc8f100568c73c82@google.com>
 <CACT4Y+bM0-QmQOQBjvGCJ+yKjXjOHHi9khDr=R4Xi79GF+Ej4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACT4Y+bM0-QmQOQBjvGCJ+yKjXjOHHi9khDr=R4Xi79GF+Ej4w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (04/01/18 12:52), Dmitry Vyukov wrote:
> 
> Seems to be the same as:
> 
> #syz dup: INFO: rcu detected stall in vprintk_func
> 
> +nfc maintainers

Yes, seems to be the same issue.

	-ss

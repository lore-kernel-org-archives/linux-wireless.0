Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbeHQRvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 13:51:49 -0400
Date: Fri, 17 Aug 2018 17:47:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>,
        Security Officers <security@kernel.org>,
        Kevin Deus <kdeus@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
Message-ID: <20180817144751.4jqwapq52z4tsnf4@mwanda> (sfid-20180817_164851_573083_5A181406)
References: <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
 <CAJuCfpHSZuabLr6+t_n7UDamJCAP6EPTNEZ6kNqWOhk2mpYADg@mail.gmail.com>
 <CAGXu5jKqcpbpG0Ky4-yXV4d5q10HtGwJtdyPKcrwkJUPhA_Mpg@mail.gmail.com>
 <CAJuCfpEX69Sbd=0i0ismP6q2NsZGUF4gMSCr1G5NdXd3n1NyZA@mail.gmail.com>
 <CAGXu5jJB9wMDJnfsurpxsXm6_0WsWWCaTuWBfy+3aMSE_LL9Rw@mail.gmail.com>
 <CAJuCfpEX+F-EPxQYXNdUg-uT9ecwYYdxBsr9y_69zQ0Fq50GeA@mail.gmail.com>
 <CAJuCfpGSPkB-tk4GHaJeStRph-ibVhUZ119Sfd16xgf9x=qUwQ@mail.gmail.com>
 <20180815082956.u6grueiyshwgqt3a@mwanda>
 <CAJuCfpH9n2vVjBF7RoMNng3T=URY1eusKfbVGyq44LWcjwNTPw@mail.gmail.com>
 <20180817120650.6mx6icxif2o52qyx@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180817120650.6mx6icxif2o52qyx@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Never mind.  This code is a bit subtle for static analysis so those
warnings are false positives.  Thanks for taking a look at this, Suren.

regards,
dan carpenter

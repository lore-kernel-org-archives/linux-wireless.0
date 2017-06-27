Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44824 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751569AbdF0Iht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 04:37:49 -0400
Message-ID: <1498552666.24675.6.camel@sipsolutions.net> (sfid-20170627_104132_978618_8D50BC55)
Subject: Re: mac80211: out of date seq number cause network stall
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?=E5=AD=99=E5=BB=BA=E5=B8=8C?= <ycsunjane@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 27 Jun 2017 10:37:46 +0200
In-Reply-To: <CABWe71y4CWD+OQDk6mCyv4DawiQd4P3CrvWp7mweQ7peJgZ+1Q@mail.gmail.com> (sfid-20170627_100706_933915_26F10D4B)
References: <CABWe71xWAruWUurYeLV=+G=tagnSmohS3KG0m-M+G9eBjrG_Ow@mail.gmail.com>
         <CABWe71xq3h42Ho3iwA8yi-xfA5eu5r_gnOr03M9n2zLgoFTV6A@mail.gmail.com>
         <CABWe71ww6Yt8dt_nrzenACZrNx8ooCp9_Ss+pwvDK8sgKDBaKA@mail.gmail.com>
         <CABWe71y4CWD+OQDk6mCyv4DawiQd4P3CrvWp7mweQ7peJgZ+1Q@mail.gmail.com>
         (sfid-20170627_100706_933915_26F10D4B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-davem, he's really not concerned with this

Hi,

I really don't think that you're looking at the right thing - you
should look at the transmitter.

Please provide a sniffer capture showing the problem.

johannes

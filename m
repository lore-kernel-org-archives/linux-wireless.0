Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34980 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935849AbdADN2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 08:28:33 -0500
Message-ID: <1483536510.7312.5.camel@sipsolutions.net> (sfid-20170104_142856_669178_D2216E87)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Shmidt <dimitrysh@google.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 04 Jan 2017 14:28:30 +0100
In-Reply-To: <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com> (sfid-20170103_214601_693369_864810F8)
References: <94eb2c110db85c2379054172dad0@google.com>
         <1480948100.31788.15.camel@sipsolutions.net>
         <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
         <1481093061.4092.17.camel@sipsolutions.net>
         <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
         <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com>
         <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
         <1481645205.20412.32.camel@sipsolutions.net>
         <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com>
         (sfid-20170103_214601_693369_864810F8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-03 at 12:45 -0800, Dmitry Shmidt wrote:
> 
> We can either use alternative structure in kernel wireless stack,
> or alternative structure in userspace (in wpa_supplicant), and we
> will most likely need special command for this case at least to
> retrieve results.

Yes, I tend to agree - we need to have some new structure (and netlink
attributes etc.) to report the aggregated/partial results. But it seems
to me that it'll have to be very obvious which way of obtaining results
must be used for a given scan?

johannes

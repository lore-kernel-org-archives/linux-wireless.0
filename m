Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45220 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HYNJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 09:09:38 -0400
Received: by qwk3 with SMTP id 3so1260925qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 06:09:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d-XCYi2nB_P-ncC=ZOX683J=5C2YNGOfcnz531nY44_Jw@mail.gmail.com>
References: <1314265865-20208-1-git-send-email-arik@wizery.com>
 <CAGXE3d9mB_jjg38Mmf+B-1RYXjFp0h2hJDkRa+c2wO_OG+BDSw@mail.gmail.com>
 <CA+XVXfd4fjtvptRJdcfqYHCkwwreFk7WfGdq9uSjVYpF6zKWcw@mail.gmail.com> <CAGXE3d-XCYi2nB_P-ncC=ZOX683J=5C2YNGOfcnz531nY44_Jw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 25 Aug 2011 16:09:23 +0300
Message-ID: <CA+XVXff9uvQgRjNuB0p47nvhuRsPB9FjcctGDbMDPT_1H5k55w@mail.gmail.com> (sfid-20110825_150941_942642_7C2155CD)
Subject: Re: [PATCH 1/2] mac80211: add flag to indicate HW only Tx-agg support
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 15:54, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> On Thu, Aug 25, 2011 at 2:38 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> Tx aggregations are done entirely in HW.
>
> Then your patch makes sense :)

Thanks.

>
> Might be worth to note that in the commit message though.

I'm waiting for more comments for now, but I agree the commit message
should be improved.

Arik

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64650 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HYMy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 08:54:27 -0400
Received: by yxj19 with SMTP id 19so1702687yxj.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 05:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfd4fjtvptRJdcfqYHCkwwreFk7WfGdq9uSjVYpF6zKWcw@mail.gmail.com>
References: <1314265865-20208-1-git-send-email-arik@wizery.com>
	<CAGXE3d9mB_jjg38Mmf+B-1RYXjFp0h2hJDkRa+c2wO_OG+BDSw@mail.gmail.com>
	<CA+XVXfd4fjtvptRJdcfqYHCkwwreFk7WfGdq9uSjVYpF6zKWcw@mail.gmail.com>
Date: Thu, 25 Aug 2011 14:54:26 +0200
Message-ID: <CAGXE3d-XCYi2nB_P-ncC=ZOX683J=5C2YNGOfcnz531nY44_Jw@mail.gmail.com> (sfid-20110825_145430_830991_37ECE649)
Subject: Re: [PATCH 1/2] mac80211: add flag to indicate HW only Tx-agg support
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 2:38 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Tx aggregations are done entirely in HW.

Then your patch makes sense :)

Might be worth to note that in the commit message though.

Thanks,
Helmut

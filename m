Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:64110 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042AbbBBKBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 05:01:11 -0500
Received: by mail-ig0-f172.google.com with SMTP id l13so16920065iga.5
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 02:01:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422614186.2675.2.camel@perches.com>
References: <1422610964-23252-1-git-send-email-helmut.schaa@googlemail.com>
	<1422614186.2675.2.camel@perches.com>
Date: Mon, 2 Feb 2015 11:01:10 +0100
Message-ID: <CAGXE3d98_336xYqCH4oeeaVJg7yq7ofqv6BLbSk0uTwdXgBERg@mail.gmail.com> (sfid-20150202_110115_298310_702BD722)
Subject: Re: [PATCH] iw: print human readable radar events
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2015 at 11:36 AM, Joe Perches <joe@perches.com> wrote:
> Might be better with a const char * use

Yeah, could do that.
However, this is consistent with the rest of the code in iw, so should
be fine as is.

Thanks,
Helmut

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:39583 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdLSUii (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 15:38:38 -0500
Received: by mail-io0-f181.google.com with SMTP id g70so2397605ioj.6
        for <linux-wireless@vger.kernel.org>; Tue, 19 Dec 2017 12:38:38 -0800 (PST)
Date: Tue, 19 Dec 2017 12:38:34 -0800
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Damian Tometzki <damian.tometzki@icloud.com>
Subject: Re: [PATCH for-4.15] wireless: create, don't append, to
 shipped-certs.c
Message-ID: <20171219203833.GA126602@google.com> (sfid-20171219_213859_242913_A47FB908)
References: <20171219192303.31395-1-briannorris@chromium.org>
 <1513714290.26145.24.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513714290.26145.24.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 19, 2017 at 09:11:30PM +0100, Johannes Berg wrote:
> I'm not really sure what that problem was - I think a combination of
> missing clean-files and this perhaps? Anyway, I applied another fix for
> this today, and it's on the way to Linus's tree, along with the missing
> clean-files and a conversion to non-binary files so that patches work
> better.

Ah, I didn't see that. I guess you just applied it a few hours ago, and
it didn't trickle into -next yet.

Thanks,
Brian

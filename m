Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36346 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdB0PK0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 10:10:26 -0500
Received: by mail-io0-f174.google.com with SMTP id l7so20006294ioe.3
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 07:10:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488207986.28431.17.camel@sipsolutions.net>
References: <1488207986.28431.17.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 27 Feb 2017 15:10:19 +0000
Message-ID: <CAKv+Gu8zSARqLY6-_XRQAC2tY0DWuYpARG0deUGLsu3qoa2AVw@mail.gmail.com> (sfid-20170227_161044_347410_BDDF250E)
Subject: Re: BUG_ON in sg code
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 February 2017 at 15:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi Ard,
>
> Apologies for the non-follow-up - couldn't find the original patch.
>
> Your patch "crypto: ccm - switch to separate cbcmac driver" causes a
> BUG_ON when virtual stacks are used, in crypto_ccm_auth() is called,
> because you put odata/idata on the stack. What's going on there? I
> thought we knew we can't do that? Did I miss something?
>

It was I who missed something, obviously.

I will send out a fix asap

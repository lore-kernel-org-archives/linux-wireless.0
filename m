Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47181 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbbJHHuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 03:50:14 -0400
Message-ID: <1444290612.2131.1.camel@sipsolutions.net> (sfid-20151008_095018_619931_9B482EA1)
Subject: Re: [PATCH] iw: Fix return values when parameters are wrong
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 08 Oct 2015 09:50:12 +0200
In-Reply-To: <CABAco3A+7-gJ6CZ+8qCnt_vnYA35dyzhjwoA4D+6D4iqi8-U=Q@mail.gmail.com> (sfid-20151007_184503_016326_2C91510D)
References: <CABAco3A+7-gJ6CZ+8qCnt_vnYA35dyzhjwoA4D+6D4iqi8-U=Q@mail.gmail.com>
	 (sfid-20151007_184503_016326_2C91510D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-07 at 18:45 +0200, Ola Olsson wrote:
> According to header file, wrong parameters
> yield 1 as return value.
> Also tried to fix the comments since one part
> of it was unreadable.
> 
That seems reasonable, but your patch (this one at least) is completely
whitespace damaged. Did you submit it through gmail's web interface?

There's some help on how to use mailers here:
https://kernel.org/doc/Documentation/email-clients.txt

johannes

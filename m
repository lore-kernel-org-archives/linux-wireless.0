Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40394 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZKGTCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 14:02:32 -0500
Received: by pwj9 with SMTP id 9so1220316pwj.21
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 11:02:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911060821r2703c186lbb75c40b449b2c55@mail.gmail.com>
References: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
	 <43e72e890911060821r2703c186lbb75c40b449b2c55@mail.gmail.com>
Date: Sat, 7 Nov 2009 11:02:37 -0800
Message-ID: <fd145f7d0911071102l3b7710fndb84fb738133dcb3@mail.gmail.com>
Subject: Re: Getting random regulatory domains on boot-up with ath9k
From: Jeffrey Baker <jwbaker@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 8:21 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Nov 6, 2009 at 12:04 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
> So one way or another user intervention is required to alter current
> regulatory solutions. For Linux though the best solution *as an end
> user* to enable AP mode is not to alter wireless-regdb but instead to
> report your issue. In your case you have a non-trivial regression
> which does indeed need to be addressed.

Thanks, your email(s) explained a great number of issues.  I don't
have the expertise to contribute here, so I leave it in your capable
hands.  I would say, however, that from the _user's_ perspective, the
best thing is if a wifi card bought in the USA from a USA retailer
automagically conformed to USA regulations, even if that's an issue to
be taken up with the card manufacturer and not with the driver
authors.

-jwb

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60120 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZJZPuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 11:50:50 -0400
Received: by mail-fx0-f218.google.com with SMTP id 18so12181469fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 08:50:55 -0700 (PDT)
Message-ID: <4AE5C55B.5070309@lwfinger.net>
Date: Mon, 26 Oct 2009 10:50:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187: kernel oops when leds enabled
References: <4AE5BD6C.2050303@gmail.com>
In-Reply-To: <4AE5BD6C.2050303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2009 10:17 AM, Richard Farina wrote:

> I'm honestly a little surprised that no one has bothered to reproduce
> this in the month since I reported it but maybe it is more unique to my
> setup than it seems.

Your machine seems to be unique in that it happens most of the time.
It took more than 10 tries, but I finally got my copy of the
wireless-testing kernel to oops.

I will be working on a patch.

Larry

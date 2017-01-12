Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:54955 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdALJoc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 04:44:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wext: handle NULL exta data in iwe_stream_add_point better
Date: Thu, 12 Jan 2017 10:44:16 +0100
Message-ID: <3158205.0GkzbOcZ01@wuerfel> (sfid-20170112_104625_489415_2B903242)
In-Reply-To: <1484212560.5391.3.camel@sipsolutions.net>
References: <20170111143532.485827-1-arnd@arndb.de> <3292373.oxnXTOSWCQ@wuerfel> <1484212560.5391.3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 12, 2017 10:16:00 AM CET Johannes Berg wrote:
> And I realized only now that this was a different place ...

Right, it was a few hundred randconfigs later after I had confirmed
that the first patch fixed all the configurations that were broken
at first.

> I've just added the check you suggested - spent way too much time
> already on this old crap 

Ok, thanks! Let's hope it doesn't come back once more.

I'm still trying to categorize the newly added warnings in gcc-7,
there a number of very useful warnings that got added, but some of
them are rather noisy and find both a number of real bugs and
false positives. The NULL check had only a few findings that all
seemed worth fixing.

	Arnd

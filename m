Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53784 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZFKPyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 11:54:51 -0400
Received: by bwz9 with SMTP id 9so1553825bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 08:54:52 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, pierre@ossman.eu, san@google.com
Subject: Re: [PATCH/RFC 0/7] wl12xx SDIO interface
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 11 Jun 2009 18:54:47 +0300
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Wed\, 10 Jun 2009 22\:02\:53 -0400")
Message-ID: <874oumyddk.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Here's v2 of the SDIO interface for wl12xx, still with a FIXME or two.
>
> For my part, this is mainly a port of the Google/TI Android SDIO
> interface logic to the existing SPI driver.  I have confirmed that
> the driver associates and sends some traffic.

I quickly read the patches and they look really good. Thanks a lot for
your work on this, you have done a great job.

About the plan how to merge these. I have quite a big pile of patches
pending for submission and I hope to send them either tomorrow or latest
on Monday. Unfortunately the patches will conflict your patches, but I
can rebase your sdio patches on top of my patches. It shouldn't take
that long. Only problem is that I don't have a device to test the SDIO,
so I might need your help with that.

Sorry about the mess, I have been sitting on top of the wl1251 patches
way too long.

-- 
Kalle Valo

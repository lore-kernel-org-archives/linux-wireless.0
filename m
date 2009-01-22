Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:40657 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZAVPME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:12:04 -0500
Received: by ug-out-1314.google.com with SMTP id 39so508596ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 07:12:02 -0800 (PST)
Subject: Re: [ath5k-devel] [PATCH 0/6] ath5k: various misc fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <1232631861-6028-1-git-send-email-me@bobcopeland.com>
References: <1232631861-6028-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 17:11:58 +0200
Message-Id: <1232637118.19795.3.camel@maxim-laptop> (sfid-20090122_161211_513595_C132C207)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-22 at 08:44 -0500, Bob Copeland wrote:
> Hi, here are some various updates for ath5k, some minor fixes, it's 
> probably all 2.6.30 material.
> 
> - patch 1 fixes a locking bug, but for consistency, not to fix any reported
>   issue
> - patches 2 and 4 are cleanups
> - patch 3 makes reset() more closely match the HAL, it may help with reset
>   errors but really is unlikely to fix any problem
> - patches 5 and 6 add missing support for some rate flags that have been
>   ignored by ath5k since forever

I tried using those 4 patches that were your attempt to fix hangs
the first one, probably helps a bit, but with them I got those 'failed
to wakeup PHY' errors that persist even after suspend/resume cycle.

Now I only use the 'continue reset sequence' and while chip locks up
from time to time, I don't see the messages about failed PHY wakeup.

Best regards,
	Maxim Levitsky


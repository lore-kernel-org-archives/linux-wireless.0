Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:47861 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZBRUp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:45:29 -0500
Received: by bwz5 with SMTP id 5so239927bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 12:45:27 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: fix Oops on disconnect
References: <c4d76b3b0902161739w2fc3bc6fp31fee6ea082702bf@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 22:45:25 +0200
In-Reply-To: <c4d76b3b0902161739w2fc3bc6fp31fee6ea082702bf@mail.gmail.com> (Jason Andryuk's message of "Mon\, 16 Feb 2009 20\:39\:06 -0500")
Message-ID: <871vtvqxsq.fsf@litku.valot.fi> (sfid-20090218_214533_153299_D53E5DC5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> flush_workqueue needs to be called instead of the generic one and the
> associated functions need to be modified to prevent re-adding
> themselves to the workqueue.
>
> The rx_tasklet is also killed in the small (?) chance it is scheduled.

Unfortunately the patch is corrupted:

patching file drivers/net/wireless/at76c50x-usb.c
Hunk #1 FAILED at 1860.
Hunk #2 FAILED at 1900.
patch: **** malformed patch at line 80: ieee80211_hw *hw,

Can you resend it?

-- 
Kalle Valo

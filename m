Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44314 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZBSGYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 01:24:07 -0500
Received: by bwz5 with SMTP id 5so629351bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 22:24:05 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: additional disconnect fixes
References: <c4d76b3b0902042003p7e2b28a0pcbf0953282becd27@mail.gmail.com>
	<da94abde0902070329s373a9edbqd9265acac8930d2a@mail.gmail.com>
	<c4d76b3b0902081947x92eb0bo73fa63afb23b5e2c@mail.gmail.com>
	<87wsbnpiws.fsf@litku.valot.fi> <1235013948.6344.12.camel@rainbow>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 19 Feb 2009 08:24:03 +0200
In-Reply-To: <1235013948.6344.12.camel@rainbow> (Jason Andryuk's message of "Wed\, 18 Feb 2009 22\:25\:48 -0500")
Message-ID: <87k57nhrlo.fsf@litku.valot.fi> (sfid-20090219_072410_996385_001E473F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> Additional attempts to fix Oops on disconnect, that appear to be
> successful. However, some may be extraneous.
>
> The cancel_delayed_work call is probably the most necessary. The
> device_unplugged check may not be necessary. del_timer_sync may not be
> necessary either, but the Oops I was receiving was related to timers.
> Hence the addition.

Thanks, looks good. I'll take this and do similarly as with the
previous patches.

-- 
Kalle Valo

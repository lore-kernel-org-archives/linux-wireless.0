Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45183 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0KZRJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 12:09:46 -0500
Received: by iwn7 with SMTP id 7so913576iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 09:09:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikgkBZPEVOuZQHeJSXiiwBsVgMOGxRwOu315Vn4@mail.gmail.com>
References: <AANLkTikCQPq-HVUJhDet-ZbA97nt+1uYTKgtzvK2cyd7@mail.gmail.com> <AANLkTikgkBZPEVOuZQHeJSXiiwBsVgMOGxRwOu315Vn4@mail.gmail.com>
From: Octav Chipara <ochipara@gmail.com>
Date: Fri, 26 Nov 2010 09:09:25 -0800
Message-ID: <AANLkTikMDT5qXrNZSdwsZDE6_rCcHnbv9pCWpHVaZo3K@mail.gmail.com>
Subject: Re: help with ath5k --- wlan0 no private ioctls
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI,

> Hmm, someone can correct me if I'm wrong, but according to my
> reading of the code, minstrel only uses hw->max_rate_tries
> and not wiphy->retry_{short,long}.  Also it looks like the only
> drivers that poke at these values only use it for failure
> indication when they don't support accurate tx status reporting.
>

Is there an easy way to control them? Can you set it through iwconfig?

Thanks,
-- Octav

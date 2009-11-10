Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:62963 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbZKJQOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 11:14:24 -0500
Received: by fxm21 with SMTP id 21so179234fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 08:14:29 -0800 (PST)
Message-ID: <4AF99161.6020308@lwfinger.net>
Date: Tue, 10 Nov 2009 10:14:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Luca Niccoli <lultimouomo@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please backport [PATCH] rtl8187: Fix kernel oops when device
 is 	removed when LEDS enabled (Bugzilla #14539)
References: <4e9568870911100747o6088ca86lf168849e6a42b91d@mail.gmail.com>
In-Reply-To: <4e9568870911100747o6088ca86lf168849e6a42b91d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2009 09:47 AM, Luca Niccoli wrote:
> I'm running 2.6.31 (from debian source) and I experienced hard freezes
> on removing the module or disconnecting the USB card.
> The patch at [1] seems to have fixed the problem, so it would be nice
> if it could be included in the 2.6.31 branch.
> Note that I was not experiencing the freezes with the distribution
> kernel, just with a self compiled one (without source modifications
> though, only config).

I'm too lazy to look for myself, and will ask here. How does Debian generate
their source? Do they cherry pick patches from upstream? If so, then they pulled
in the changed behavior in mac80211 that triggered the bug. I ran more than 2000
insmod/rmmod cycles with vanilla 2.6.31 from Linus's tree without seeing a
single failure.

I will, however, send the patch to Greg K-H for inclusion in 2.6.31.Y.

Larry


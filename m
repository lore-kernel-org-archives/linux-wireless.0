Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:41119 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZHFOaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 10:30:12 -0400
Received: by pzk34 with SMTP id 34so934395pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 07:30:13 -0700 (PDT)
Message-ID: <4A7AE8E6.4050301@lwfinger.net>
Date: Thu, 06 Aug 2009 09:29:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de,
	gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [PATCH] b43: Fix hardware key index handling
References: <200908061036.50631.mb@bu3sch.de>
In-Reply-To: <200908061036.50631.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This fixes the hardware encryption keys index and array size handling.
> 
> Thanks to Gregor Kowski for reporting this issue.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This should probably go as a bugfix.
> (Does this actually fix the PHY transmission errors? I don't see them anymore...
> Note that you need to enable debugging to see them.)

I still see the PHY transmission errors. I had two of them and a "RX:
packet dropped" debug message within seconds of reloading b43 with
this patch included.

Larry

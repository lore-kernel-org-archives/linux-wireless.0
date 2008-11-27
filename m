Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:51853 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYK0PQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 10:16:15 -0500
Received: by ey-out-2122.google.com with SMTP id 6so445079eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 07:16:13 -0800 (PST)
Message-ID: <f76a32050811270716u100d0c7fm7d09259f1683f75@mail.gmail.com> (sfid-20081127_161620_456486_061BE40E)
Date: Thu, 27 Nov 2008 16:16:13 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200811271542.23390.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200811242124.16358.chunkeey@web.de>
	 <f76a32050811270605s606cc0acjd419987235db44f4@mail.gmail.com>
	 <1227795234.3809.94.camel@johannes.berg>
	 <200811271542.23390.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But I don't know what to do with set-and-clear.diff
> (I guess it's still one of the three patches, or?, I've attached it again,
> in case johannes missed it? ).
> Is it really necessary or does your application work without it?

I have done a very quick test of that (exactly what I had before MINUS
the set-and-clear.diff).
I don't see any problems.
I recommend not to include this patch at this time.

I am without the hardware until Dec 8, but will continue testing after that.
CCMP is on my list (have only done unencrypted stuff yet).

Best regards,
  Stefan.

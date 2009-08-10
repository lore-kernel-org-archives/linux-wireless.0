Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:24060 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbZHJQCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 12:02:52 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1031262rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 09:02:53 -0700 (PDT)
Message-ID: <4A8044A9.8090600@lwfinger.net>
Date: Mon, 10 Aug 2009 11:02:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH] b43: Implement LP-PHY baseband table initialization
References: <4A7F713E.8040405@gmail.com> <4A7F811F.4070908@lwfinger.net> 	<69e28c910908100437n46a04f76tf91876d48ab19cb4@mail.gmail.com> 	<4A8034D4.5030909@lwfinger.net> <69e28c910908100842o6eecb131n50ff39fc48566880@mail.gmail.com>
In-Reply-To: <69e28c910908100842o6eecb131n50ff39fc48566880@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 2009/8/10 Larry Finger <Larry.Finger@lwfinger.net>:
>> Yes, that would work for the 2.4 GHz band, and I guess there could be
>> similar routines or macros to split the 5 GHz band into low, medium
>> and high channels.
> 
> AFAIK there is no need to do that - using current_band for 2GHz is
> specifically to ensure that channels in the 2500...3000MHz range don't
> get parsed as 5GHz. There is currently no band above 5GHz used for
> wlan, so this problem can't show up on 5GHz.

OK.

> I'm gonna re-submit this as a formal patch soon.

Good.

I just noticed that
http://bcm-v4.sipsolutions.net/802.11/PHY/LP/Calibration is
incomplete. I'll work on that next.

Larry


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:21419 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZJYP6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2009 11:58:00 -0400
Received: by fg-out-1718.google.com with SMTP id 16so4600463fgg.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2009 08:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910251654.17050.mb@bu3sch.de>
References: <1256484396-31063-1-git-send-email-netrolller.3d@gmail.com>
	<200910251654.17050.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 25 Oct 2009 16:57:44 +0100
Message-ID: <69e28c910910250857l341cc114w46224b94cda36f3e@mail.gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Begin implementing calibration & software
	RFKILL support
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/10/25 Michael Buesch <mb@bu3sch.de>:
> On Sunday 25 October 2009 16:26:36 Gábor Stefanik wrote:
>> Michael, could you please do the PHY reset part? I can't seem to
>> understand its relationship to wireless_core_reset... also, it's
>> heavily ssb-speak, which I am not good at.
>
> Where are the specifications?
>
> --
> Greetings, Michael.
>

They are @ http://bcm-v4.sipsolutions.net/802.11/PHY/Reset - it shows
some similarity to wireless_core_reset, but it is not an exact match.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

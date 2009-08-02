Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:17561 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZHBWYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 18:24:49 -0400
Received: by fg-out-1718.google.com with SMTP id e21so918461fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 15:24:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7610AE.5000908@gmail.com>
References: <4A7610AE.5000908@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 3 Aug 2009 00:24:29 +0200
Message-ID: <69e28c910908021524r1bf8d0a3s3cab303ff9fc6c0b@mail.gmail.com>
Subject: Re: [PATCH RESEND] b43: implement baseband init for LP-PHY <= rev1
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/3 Gábor Stefanik <netrolller.3d@gmail.com>:
> Implement baseband init for rev.0 and rev.1 LP PHYs. Convert
> boardflags_hi values to defines.
> Implement b43_phy_copy for easier copying between registers, as needed
> by LP-PHY init.
>
> Signed-off-by: Gábor Stefanik<netrolller.3d@gmail.com>
> Cc: Michael Buesch<mb@bu3sch.de>
> Cc: Larry Finger<larry.finger@lwfinger.net>
> ---
>

Looks like this one survived.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:62167 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZHBXbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 19:31:50 -0400
Received: by fg-out-1718.google.com with SMTP id e12so400824fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 16:31:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A76210C.4040209@gmail.com>
References: <4A76210C.4040209@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 3 Aug 2009 01:31:29 +0200
Message-ID: <69e28c910908021631g256560c8q364674b6e907f235@mail.gmail.com>
Subject: Re: [PATCH V2] b43: implement baseband init for LP-PHY <= rev1
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 3, 2009 at 1:28 AM, Gábor Stefanik<netrolller.3d@gmail.com> wrote:
> Implement baseband init for rev.0 and rev.1 LP PHYs. Convert boardflags_hi
> values to defines.
> Implement b43_phy_copy for easier copying between registers, as needed by
> LP-PHY init.
>
> Signed-off-by: Gábor Stefanik<netrolller.3d@gmail.com>
> Cc: Michael Buesch<mb@bu3sch.de>
> Cc: Larry Finger<larry.finger@lwfinger.net>
> ---
> V2:
> -Reversed argument order for b43_phy_copy.
> -Named all registers, no more magic numbers.
> -Whitespace errors hopefully fixed (I hope my mailer doesn't re-introduce
> them...)

Phew! No more whitespace corruption, it seems... looks like
Thunderbird doesn't like the Linux coding style. :-)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

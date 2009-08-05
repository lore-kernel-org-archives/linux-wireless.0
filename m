Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:40423 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286AbZHECjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 22:39:25 -0400
Received: by pzk34 with SMTP id 34so3253972pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 19:39:26 -0700 (PDT)
Message-ID: <4A78F0DC.4070104@lwfinger.net>
Date: Tue, 04 Aug 2009 21:39:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3] b43: implement baseband init for LP-PHY <= rev1
References: <4A78C336.9000503@gmail.com>
In-Reply-To: <4A78C336.9000503@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Implement baseband init for rev.0 and rev.1 LP PHYs. Convert
> boardflags_hi values to defines.
> Implement b43_phy_copy for easier copying between registers, as needed
> by LP-PHY init.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Larry Finger <larry.finger@lwfinger.net>
> ---
> V3:
> -Added FIXME to the b43_hf_write call.
> -The b43_hf_write call now uses a #defined value, rather than a magic
> number.

It looks to me that V2 was put into wireless-testing. You will need to
prepare a separate patch to make the V2 => V3 changes.

Larry


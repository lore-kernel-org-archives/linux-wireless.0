Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:25270 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZHBWUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 18:20:06 -0400
Received: by rv-out-0506.google.com with SMTP id f6so923189rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 15:20:07 -0700 (PDT)
Message-ID: <4A761134.3010807@lwfinger.net>
Date: Sun, 02 Aug 2009 17:20:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH] b43: implement baseband init for LP-PHY <= rev1
References: <4A760DF5.6050504@gmail.com>
In-Reply-To: <4A760DF5.6050504@gmail.com>
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

Your mailer mangled the white space and wrapped long lines in the patch.

Larry

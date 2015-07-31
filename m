Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33837 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbGaMtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 08:49:24 -0400
Received: by pacan13 with SMTP id an13so41437554pac.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2015 05:49:22 -0700 (PDT)
Date: Fri, 31 Jul 2015 18:19:15 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 00/28] removing the compile warnings for 64-bit
Message-ID: <20150731124915.GD8541@sudip-pc> (sfid-20150731_145006_010153_E813FCBB)
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 04:38:08PM +0900, Tony Cho wrote:
> Hi Greg,
> This patch focuses on removing the compile warnings for 64bit incompatability.
> Most warnings are due to senseless type castings from driver handler to u32 and
> also to void pointers. They are removed by using the same handler with this
> series of patch. All warnings disappear.
At the end of the series it has no warnings on my 64bit system. But some
of the patch in the series increased the number of warnings.
Before this series I had 77 warnings. patch 1/28 increased that to 82.
patch 4/28 increased the number of warnings to 133. But after that it
started gradually decreasing. And at the end 0.

regards
sudip

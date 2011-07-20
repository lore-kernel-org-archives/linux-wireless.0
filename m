Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56355 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1GTPrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 11:47:10 -0400
Message-ID: <4E26F879.8010601@lwfinger.net> (sfid-20110720_174732_561034_BF24431D)
Date: Wed, 20 Jul 2011 10:47:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wireless: rtlwifi: throw away MAC_FMT and use %pM
 instead
References: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2011 08:34 AM, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko<andriy.shevchenko@linux.intel.com>
> Cc: Larry Finger<Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/base.c         |   11 +++++------
>   drivers/net/wireless/rtlwifi/cam.c          |    4 ++--
>   drivers/net/wireless/rtlwifi/core.c         |    6 +++---
>   drivers/net/wireless/rtlwifi/debug.h        |    5 -----
>   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192de/hw.c |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c |    2 +-
>   7 files changed, 13 insertions(+), 19 deletions(-)

ACK.  Thanks for the patch.

Larry

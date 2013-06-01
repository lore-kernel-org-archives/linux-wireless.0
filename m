Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36322 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FAMNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:13:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <linux-wireless@vger.kernel.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] wireless: ath6kl: re-use native helper to parse MAC
References: <1366896682-2023-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Sat, 1 Jun 2013 15:13:01 +0300
In-Reply-To: <1366896682-2023-1-git-send-email-andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Thu, 25 Apr 2013 16:31:22 +0300")
Message-ID: <87obbqni5u.fsf@kamboji.qca.qualcomm.com> (sfid-20130601_141311_431528_15176781)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> There is native mac_pton() function which helps to parse MAC.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks, applied.

-- 
Kalle Valo

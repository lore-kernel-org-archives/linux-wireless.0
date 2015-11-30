Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37889 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbbK3M7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 07:59:50 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/1] wireless: airo: re-use mac_pton()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1448641771-140820-1-git-send-email-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Message-Id: <20151130125950.0AF0C1409E0@smtp.codeaurora.org> (sfid-20151130_135952_981178_F0F453B7)
Date: Mon, 30 Nov 2015 12:59:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> mac_pton() converts 6-byte MAC / BSSID to binary format. Change an open coded
> variant by the generic one.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

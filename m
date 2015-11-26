Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44674 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbKZNCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 08:02:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/1] rtlwifi: btcoexist: re-use %*ph specifier to hexdump
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1447855758-68099-1-git-send-email-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Message-Id: <20151126130217.5D91D14073A@smtp.codeaurora.org> (sfid-20151126_140220_776467_6A39344D)
Date: Thu, 26 Nov 2015 13:02:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Instead of printing each byte from the given buffer the code is converted to
> use %*ph specifier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

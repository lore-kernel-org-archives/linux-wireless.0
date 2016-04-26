Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50454 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbcDZJKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:10:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v3] prism54: isl_38xx: Replace 'struct timeval'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160413060916.GA21184@localhost>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Message-Id: <20160426091014.6ADE46120F@smtp.codeaurora.org> (sfid-20160426_111047_718378_617A2C5F)
Date: Tue, 26 Apr 2016 09:10:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 'struct timeval' uses a 32-bit seconds field which will overflow in
> year 2038 and beyond. This patch is part of a larger effort to remove
> all instances of 'struct timeval' from the kernel and replace them
> with 64-bit timekeeping variables.
> The patch also fixes the debug printf specifier to avoid the
> seconds value being truncated.
> The patch was build-tested / debugged by removing the
> "if VERBOSE > SHOW_ERROR_MESSAGES" guards.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

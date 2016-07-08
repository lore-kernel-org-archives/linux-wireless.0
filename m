Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39977 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbcGHJ7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 05:59:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Add missing newlines to RT_TRACE calls
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <5677791872bfb47963780c198c825d882456720f.1466969647.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160708095905.632BA611B8@smtp.codeaurora.org> (sfid-20160708_115911_220952_618319C4)
Date: Fri,  8 Jul 2016 09:59:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> wrote:
> RT_TRACE does not add a newline to the end of a message and always
> emits at KERN_DEBUG so these are susceptible to message interleaving
> from other processes without the newline.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

4713bd1c7407 rtlwifi: Add missing newlines to RT_TRACE calls

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9199581/


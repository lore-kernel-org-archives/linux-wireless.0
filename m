Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:46088 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbbA0SAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 13:00:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtl8192cu: fix the mesh beaconing
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422003564-22414-1-git-send-email-yeohchunyeow@gmail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	linville@tuxdriver.com, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Message-Id: <20150127180031.78C38140E1A@smtp.codeaurora.org> (sfid-20150127_190035_093911_4B425F30)
Date: Tue, 27 Jan 2015 18:00:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Patch "rtlwifi: add support to send beacon frame" allows
> the beaconing of rtl8192cu. But mesh beaconing is not
> working. Fix this.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

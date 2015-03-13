Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52487 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbCMOVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 10:21:55 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192cu: remove unused arguments from
 _beacon_function_enable()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425913628-6415-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150313142154.7FDE2141774@smtp.codeaurora.org> (sfid-20150313_152158_170859_0451AC89)
Date: Fri, 13 Mar 2015 14:21:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Remove unnecessary parameter in rtl8192cu/hw.c
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, applied to wireless-drivers-next.git. I just changed the title based on
Larry's comment:

708c964c5df8 rtlwifi: rtl8192cu: remove unused arguments from _beacon_function_enable()

Kalle Valo

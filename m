Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35982 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbcEKTCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 15:02:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: airo: prevent potential underflow in airo_set_freq()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160510192037.GB30712@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Felipe Balbi <felipe.balbi@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20160511190211.9054D6133D@smtp.codeaurora.org> (sfid-20160511_210217_161764_B56CA537)
Date: Wed, 11 May 2016 19:02:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> I'm not sure if this can underflow but Smatch complains.  It seems
> harmless to add a check for negatives.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

03ba4a1b718e airo: prevent potential underflow in airo_set_freq()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9061381/


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12795 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab3EPWQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 18:16:18 -0400
Date: Fri, 17 May 2013 00:16:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org
Subject: Re: [PATCH] NFC: pn533: fix error return code in pn533_probe()
Message-ID: <20130516221614.GP22822@zurbaran> (sfid-20130517_001626_501161_4072E757)
References: <CAPgLHd98BDZihsvkMR-o6Z2y6QwPtXwEm9_7meXcLrjHcCDe7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd98BDZihsvkMR-o6Z2y6QwPtXwEm9_7meXcLrjHcCDe7Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On Tue, May 07, 2013 at 08:07:52PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the nfc device alloc error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/nfc/pn533.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

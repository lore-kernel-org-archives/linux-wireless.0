Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1177 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab3BVNuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 08:50:20 -0500
Message-ID: <5127778F.8070005@broadcom.com> (sfid-20130222_145023_451209_63806FA0)
Date: Fri, 22 Feb 2013 14:50:07 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Wei Yongjun" <weiyj.lk@gmail.com>
cc: brudley@broadcom.com, meuleman@broadcom.com,
	linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH -next] brcmfmac: fix missing unlock on error in
 brcmf_notify_vif_event()
References: <CAPgLHd8kCr1-vGNzpf5wb36bYaHYd3=x5oSC_xeBcRb7DANB1w@mail.gmail.com>
In-Reply-To: <CAPgLHd8kCr1-vGNzpf5wb36bYaHYd3=x5oSC_xeBcRb7DANB1w@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2013 02:32 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function brcmf_notify_vif_event()
> in the error handling case.

We have a fix for this one, but not yet submitted. This issue was:

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

If you add that to the commit message, you have my:
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Regards,
Arend


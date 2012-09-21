Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13216 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2IUQmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 12:42:51 -0400
Message-ID: <505C9905.2000003@qca.qualcomm.com> (sfid-20120921_184259_581212_B0DE7BB1)
Date: Fri, 21 Sep 2012 19:42:45 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <linville@tuxdriver.com>, <yongjun_wei@trendmicro.com.cn>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: use list_move_tail instead of list_del/list_add_tail
References: <CAPgLHd-6RmrLpi9FPTFhXiA+BHywGknmvNAd-KCdHaM+tn0qgQ@mail.gmail.com>
In-Reply-To: <CAPgLHd-6RmrLpi9FPTFhXiA+BHywGknmvNAd-KCdHaM+tn0qgQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 10:07 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, applied to ath6kl.git.

Kalle

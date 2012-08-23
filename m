Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37014 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934412Ab2HWVMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 17:12:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_zKkfbms8pMPiTKtGxWXw9=b0+AftqFxWZCPLb3EBaig@mail.gmail.com>
References: <CAPgLHd_zKkfbms8pMPiTKtGxWXw9=b0+AftqFxWZCPLb3EBaig@mail.gmail.com>
Date: Fri, 24 Aug 2012 01:12:09 +0400
Message-ID: <CA++WF2O2SJ+_gATBXrDaoGZ2DA18gK=qM8Y4E9No84J3RCW5XA@mail.gmail.com> (sfid-20120823_231219_067006_168C2D16)
Subject: Re: [PATCH] ipw2100: use is_zero_ether_addr() and is_broadcast_ether_addr()
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 23 August 2012 10:53, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using is_zero_ether_addr() and is_broadcast_ether_addr() instead of
> directly use memcmp() to determine if the ethernet address is all zeros.
>
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/net/wireless/ipw2x00/ipw2100.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)

Looks fine, thanks.

Stanislav.

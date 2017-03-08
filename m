Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50806 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753899AbdCHR6q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 12:58:46 -0500
Date: Wed, 8 Mar 2017 07:56:46 -0800
From: Kyle McMartin <kyle@infradead.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-firmware@kernel.org
Subject: Re: [PATCH] ath10k: QCA6174 hw3.0: update board-2.bin
Message-ID: <20170308155646.GE13400@bombadil.infradead.org> (sfid-20170308_185854_905426_2702FCF1)
References: <1488983536-28364-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1488983536-28364-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 08, 2017 at 04:32:16PM +0200, Kalle Valo wrote:
> Add new board images:
> 
> bus=pci,vendor=168c,device=003e,subsystem-vendor=1a56,subsystem-device=1535,variant=RV_0520
> bus=pci,vendor=168c,device=003e,subsystem-vendor=1a56,subsystem-device=1535,variant=RV_0519
> bus=pci,vendor=168c,device=003e,subsystem-vendor=1028,subsystem-device=0310,variant=RV_0519
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied, thanks Kalle.

regards, Kyle

> ---
>  ath10k/QCA6174/hw3.0/board-2.bin | Bin 337204 -> 361924 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)
> 
> diff --git a/ath10k/QCA6174/hw3.0/board-2.bin b/ath10k/QCA6174/hw3.0/board-2.bin
> index 8e7b8c0b0cae7f7ac15ef5ca42fa5bcca6ad66c2..ea18004951fed49aa9214093fa900427e4960a5d 100644
> GIT binary patch
> delta 572
> zcmdmTO5{klSVIeA3sVbo3(FQ(6V=HMDlD8D3JhQnJ)Q9>i=T{6Sz=LUVqS@DP*}Wy
> zsi9>qBT#maJO~$V{@tL>A-Q}_K`96?T2s|Bc@ctMK6yWfu7qNen23CW1haf%Bx87D
> zFcXa4{^TvoUq0QQ30rpTJ$Tj!O8bSS^-Wv1|9DW+q(z$!GccfvPtS{CN!I6&;**k$
> zl8EAs;+B$#5*Ln?;D`(rj^q~Pk(3l*V1SA9M~ZMn1`0%Mc9>bgj^wL@3mN@n@%Soq
> z!{$2)S{x#sK(9bB&|5P=Y#_ah!$?9gF;QMVF;P}NAwf1IAwdX6Z%)Z%=I1=?6O#e*
> z)7i-d6{5^QuTAc#$kdOEi<1T7C?J*r(Nb};VsVmk5fYKHu@OKw17#wm5#pN_DhavS
> z$N(uOww(dGS)XHi_8Df!%|4k@{2IU@1-s+mS--fnY3sHj1u2U7<i3hjodnsqq@<{%
> exC9vxtrVA#kRYiPB_XMx0CF3u_-6UaQg#61GR2|*
> 
> delta 19
> acmX@oEw<&9NJ9%_3sVbo3(FQ(6IB3C%Lb$X
> 
> -- 
> 2.7.4
> 
> 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36421 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbcBBQm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 11:42:28 -0500
Date: Tue, 2 Feb 2016 22:12:12 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: punit vara <punitvara@gmail.com>
Cc: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND,01/10] net: wireless: ath: Remove unnecessary semicolon
Message-ID: <20160202164212.GD8235@sudip-laptop> (sfid-20160202_174249_608677_0C41C2A4)
References: <1445972565-14963-1-git-send-email-punitvara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445972565-14963-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 12:32:36AM +0530, punit vara wrote:
> This patch is to the htt_rx.c that removes unneeded semicolon which is
> reported by coccicheck.
> 
> Here semicolon just create empty statement so please remote it.

s/remote/remove

Instead of "net: wireless: ath: Remove unnecessary semicolon" the subject
should be "ath10k: Remove unnecessary semicolon"

and please combine this patch and the next patch as they are similar
change to the same driver.

regards
sudip

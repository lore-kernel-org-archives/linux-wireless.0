Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbcCJQaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 11:30:17 -0500
Date: Thu, 10 Mar 2016 08:30:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: akolli@qti.qualcomm.com
Cc: ath10k@lists.infradead.org, akolli@codeaurora.org,
	stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix debugfs pktlog_filter write
Message-ID: <20160310163010.GA29861@kroah.com> (sfid-20160310_173023_419791_4C617276)
References: <1457601538-30751-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457601538-30751-1-git-send-email-akolli@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2016 at 02:48:58PM +0530, akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
> 
> It is observed that, we are disabling the packet log if we write same
> value to the pktlog_filter for the second time. Always enable pktlogs
> on non zero filter.
> 
> Fixes: 90174455ae05 ("ath10k: add support to configure pktlog filter")
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

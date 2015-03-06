Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3516 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbCFHkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 02:40:16 -0500
Date: Fri, 6 Mar 2015 13:09:44 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <mka@google.com>
Subject: Re: [PATCH 2/2] ath10k: fix quiet duration configuration
Message-ID: <20150306073936.GA3982@qca.qualcomm.com> (sfid-20150306_084021_262926_A5576BC7)
References: <1424368506-18193-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1424368506-18193-2-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1424368506-18193-2-git-send-email-rmanohar@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2015 at 11:25:06PM +0530, Rajkumar Manoharan wrote:
> Duty cycle is nothing but percentage of one period in which a
> signal is active. But it is wrongly interpreted as ratio of quiet
> duration. So fix the quiet duration to the remaining percentage
> of duty cycle (active ratio).
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
Kalle,

Please drop this change as it breaks the user space interface. Will send
updated patch ASAP. Sorry for the inconvenience.

-Rajkumar

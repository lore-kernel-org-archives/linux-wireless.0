Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5158 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab2FAGOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 02:14:14 -0400
Date: Fri, 1 Jun 2012 11:45:22 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 20/22] ath9k: always perform ani calibration at poll
Message-ID: <20120601061520.GA740@vmraj-lnx.users.atheros.com> (sfid-20120601_081450_935958_EF2F80FE)
References: <20413.45867.862989.977871@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20413.45867.862989.977871@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2012 at 09:33:55AM +0530, Sujith Manoharan wrote:
> 
> From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> Skiping the ani based on power state is delaying the ani cycles
> further on an idle state. And also as the power state is updated
> in different contexts, let us not skip the ani calibration.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    5 -----
>  1 file changed, 5 deletions(-)
John,

Can you please drop this patch alone from the patch series as it does
not make any improvement. Sorry for the inconvenience.

--
Rajkumar

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1969 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaEWIbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:31:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Frederic Danis <frederic.danis@linux.intel.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix ath10k_bmi_read32 macro
References: <1400249601-24899-1-git-send-email-frederic.danis@linux.intel.com>
Date: Fri, 23 May 2014 11:31:12 +0300
In-Reply-To: <1400249601-24899-1-git-send-email-frederic.danis@linux.intel.com>
	(Frederic Danis's message of "Fri, 16 May 2014 16:13:21 +0200")
Message-ID: <87k39cvqum.fsf@kamboji.qca.qualcomm.com> (sfid-20140523_103137_281044_5C5908D4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frederic Danis <frederic.danis@linux.intel.com> writes:

> tmp may be used uninitialized if ath10k_bmi_read_memory() returns
> an error.
>
> Signed-off-by: Frederic Danis <frederic.danis@linux.intel.com>

Thanks, applied.

-- 
Kalle Valo

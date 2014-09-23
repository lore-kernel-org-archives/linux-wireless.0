Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24153 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaIWOic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 10:38:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: don't enable interrupts for the diagnostic window
In-Reply-To: <20140923143219.23585.34114.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 23 Sep 2014 17:32:19 +0300")
References: <20140923143219.23585.34114.stgit@potku.adurom.net>
Date: Tue, 23 Sep 2014 17:38:27 +0300
Message-ID: <87d2amcsgs.fsf@kamboji.qca.qualcomm.com> (sfid-20140923_163835_533876_1C37F7BE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I forgot add --edit-cover to stg. So here's the cover letter :)

ath10k: export calibration data to user space

here's a small patchset exporting firmware calibration data to user space. This
makes it easier to debug various calibration data related problems.

Please comment.

v2:

* never unmask the diagnostic window copy engine pipe in
  ath10k_ce_enable_interrupts()

* add locking for diag_read_mem()/diag_write_mem()

-- 
Kalle Valo

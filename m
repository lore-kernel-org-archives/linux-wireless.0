Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23855 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbaGNMuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 08:50:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Frederic Danis <frederic.danis@linux.intel.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>
Subject: Re: [PATCH v2] ath6kl: Fix ath6kl_bmi_read_hi32 macro
References: <87oayi6mei.fsf@kamboji.qca.qualcomm.com>
	<1401711470-31267-1-git-send-email-frederic.danis@linux.intel.com>
Date: Mon, 14 Jul 2014 15:50:33 +0300
In-Reply-To: <1401711470-31267-1-git-send-email-frederic.danis@linux.intel.com>
	(Frederic Danis's message of "Mon, 2 Jun 2014 14:17:50 +0200")
Message-ID: <87ha2km7dy.fsf@kamboji.qca.qualcomm.com> (sfid-20140714_145107_185643_095A1FBF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frederic Danis <frederic.danis@linux.intel.com> writes:

> tmp may be used uninitialized if ath6kl_bmi_read() returns an error.
>
> Signed-off-by: Frederic Danis <frederic.danis@linux.intel.com>

Thanks, applied.

-- 
Kalle Valo

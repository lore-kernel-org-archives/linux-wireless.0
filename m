Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27878 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbbCOIZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:25:03 -0400
Date: Sun, 15 Mar 2015 13:54:43 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k: fix wrong symlink name on error path
Message-ID: <20150315082440.GC18213@qca.qualcomm.com> (sfid-20150315_092509_555952_8EFBEAD1)
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1424437452-28161-2-git-send-email-rmanohar@qti.qualcomm.com>
 <87h9tqv09b.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87h9tqv09b.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2015 at 03:00:32PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Wrong symlink name is used on error path of thermal registration
> > and also correcting the error message.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> Thanks, patch 2 applied. Not sure yet what to do with patch 1 and 3.
>
Will rework on patch 1 (ath10k: add sysfs entry to configure quiet
period) to use debugfs instead of sysfs. Patch 3 can be dropped.

-Rajkumar

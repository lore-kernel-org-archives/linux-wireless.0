Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52526 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbbCRImX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 04:42:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Kyle McMartin <kyle@infradead.org>
CC: <linux-firmware@kernel.org>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: add firmware 10.2.4.45 as firmware-4.bin
References: <1426160112-4261-1-git-send-email-kvalo@qca.qualcomm.com>
	<20150313204730.GA30928@merlin.infradead.org>
Date: Wed, 18 Mar 2015 10:42:12 +0200
In-Reply-To: <20150313204730.GA30928@merlin.infradead.org> (Kyle McMartin's
	message of "Fri, 13 Mar 2015 16:47:30 -0400")
Message-ID: <87lhiuofx7.fsf@kamboji.qca.qualcomm.com> (sfid-20150318_094231_402728_0ADEBBFF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kyle McMartin <kyle@infradead.org> writes:

> On Thu, Mar 12, 2015 at 01:35:12PM +0200, Kalle Valo wrote:
>> This is the latest firmware from 10.2.4 firmware branch.
>> 
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> Pardon my ignorance... It looks like your driver needs more than just
> firmware-4.bin... How are distros supposed to use this? Symlink it into
> firmware.bin which it seems the driver looks for?

The current version of ath10k uses firmware-4.bin. Distros should not
create symlinks or anything like that.

-- 
Kalle Valo

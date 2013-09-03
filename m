Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34122 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3ICHA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 03:00:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ath10k: detect hw1.0 boards
References: <20130901082007.1930.79088.stgit@localhost6.localdomain6>
Date: Tue, 3 Sep 2013 10:00:50 +0300
In-Reply-To: <20130901082007.1930.79088.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sun, 01 Sep 2013 11:22:06 +0300")
Message-ID: <87ioyi1ja5.fsf@kamboji.qca.qualcomm.com> (sfid-20130903_090103_379722_70D7898A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Here's a patchset which detects hw1.0 from the
> chip id register and fails the probe if found.
>
> v2:
>
> o use SOC_CHIP_ID_REV_MASK
>
> o move detection to core.c so that it's not just PCI
>   specific
>
> o add debugfs file for reading the chip id
>
> ---
>
> Kalle Valo (2):
>       ath10k: check chip id from the soc register during probe
>       ath10k: add chip_id file to debugfs

Both patches applied, but I fixed the commit log in patch 1 based on the
discussion.

-- 
Kalle Valo

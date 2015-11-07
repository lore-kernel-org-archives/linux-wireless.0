Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbbKGIoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2015 03:44:12 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <gregkh@linuxfoundation.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: patch "ath10k: drop probe responses when too many are queued" added to staging-testing
References: <14468483293347@kroah.com>
Date: Sat, 7 Nov 2015 10:43:52 +0200
In-Reply-To: <14468483293347@kroah.com> (gregkh@linuxfoundation.org's message
	of "Fri, 6 Nov 2015 14:18:49 -0800")
Message-ID: <87mvuq9p2v.fsf@kamboji.qca.qualcomm.com> (sfid-20151107_094416_350966_7C84F56A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

<gregkh@linuxfoundation.org> writes:

> This is a note to let you know that I've just added the patch titled
>
>     ath10k: drop probe responses when too many are queued
>
> to my staging git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> in the staging-testing branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will be merged to the staging-next branch sometime soon,
> after it passes testing, and the merge window is open.
>
> If you have any questions about this process, please let me know.

Did you apply this and the few other ath10k patches to staging by
mistake? I had already applied them to my ath.git tree and linus already
has them:

7b7da0a02192 ath10k: drop probe responses when too many are queued

-- 
Kalle Valo

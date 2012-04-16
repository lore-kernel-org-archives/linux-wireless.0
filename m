Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47993 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752168Ab2DPTTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:19:15 -0400
Message-ID: <1334603908.1788.1.camel@joe2Laptop> (sfid-20120416_211919_133270_19602AB6)
Subject: Re: Checkpatch warnings with pr_fmt()
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 16 Apr 2012 13:18:28 -0600
In-Reply-To: <4F868445.1030209@qca.qualcomm.com>
References: <4F868445.1030209@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-12 at 10:29 +0300, Kalle Valo wrote:
> due to checkpatch warnings in ath6kl, from a recent pr_fmt() addition, I
> had to update checkpatch and now I get lots of useless warnings like this:
> 
> drivers/net/wireless/ath/ath6kl/common.h:28: CHECK: Don't begin block
> comments with only a /* line, use /* comment...
> drivers/net/wireless/ath/ath6kl/bmi.h:233: CHECK: No space is necessary
> after a cast
> 
> IMHO they are wrong, at least the style I have tried to enforce in
> ath6kl is totally opposite (I have "/*\n" on multiline comments and a
> space after a cast). And at least CodingStyle seems to recommend my
> style for the multiline comments.

It's the style David Miller prefers for drivers/net.
I don't much care one way or another.

> Would you consider removing these two warnings? Or maybe add a new check
> level so that I can easily disable them?

./scripts/checkpatch.pl --ignore=BLOCK_COMMENT_STYLE <foo>




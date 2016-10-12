Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933044AbcJLOP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 10:15:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de
Subject: Re: [PATCH] rsi: fix memory lean in module unload
References: <1474437546-6590-1-git-send-email-prameela.j04cs@gmail.com>
Date: Wed, 12 Oct 2016 17:14:35 +0300
In-Reply-To: <1474437546-6590-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Wed, 21 Sep 2016 11:29:06
        +0530")
Message-ID: <87shs1ejsk.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_161532_146962_6094DD75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> Moved debugfs entry removal under CONFIG_RSI_DEBUGFS flag
> Added freeing of below structures
>  * channels list in each supported band
>  * rsi debugfs info
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

There are four similar patches without any version information:

[  1] rsi: fix memory leak in debugfs entry and supported bands    2016-09-19 Prameela Ran Deferred
[  2] [1/1] rsi: fix memory leak in debugfs entry and supported... 2016-09-20 Prameela Ran Deferred
[  3] rsi: fix memory lean in module unload                        2016-09-21 Prameela Ran Deferred
[  4] rsi: fix memory leak in module unload                        2016-09-21 Prameela Ran Deferred

When sending a new version of the patch please add a version number to
it. See the instructions for more:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject_name

-- 
Kalle Valo

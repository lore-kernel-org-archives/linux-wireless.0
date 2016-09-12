Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932839AbcILMxw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 08:53:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 0/9] rsi: code clean-up
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Date: Mon, 12 Sep 2016 15:53:45 +0300
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com> (Prameela Rani
        Garnepudi's message of "Mon, 12 Sep 2016 15:08:15 +0530")
Message-ID: <87sht5mg86.fsf@kamboji.qca.qualcomm.com> (sfid-20160912_145356_416353_E0B55C91)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> *** BLURB HERE ***

This has a meaning :)

> Prameela Rani Garnepudi (9):
>   rsi: cleanup and added debug prints in file rsi_91x_core.c
>   rsi: Spelling and code format corrections in rsi_91x_debugfs.c
>   rsi: Added freeing of allocated buffers (sbands and dfsentry)         
>     Cleanup (spelling mistakes, code format corrections,     	     
>     empty lines after declaration)
>   rsi: code clean up in file rsi_91x_main.c
>   rsi: code cleanup in file rsi_91x_mgmt.c
>   rsi: code cleanup (spelling mistakes and new line after declaration)
>     in file rsi_91x_sdio.c          Added developer name
>   rsi: zone changed for debug message and cleanup in file
>     rsi_91x_sdio_ops.c
>   rsi: code clean up and replaced ctrl message timeouts with macros in
>     file rsi_91x_usb.c
>   rsi: code cleanup in file rsi_91x_usb_ops.c

Usually patches are split based on type of changes, not by files
affected. So one patch does one type of logical change to all files in
the driver and another patch does again something else. Also the commit
logs are not correctly formatted, for example the title is too long.

I recommend to start with something small, for example one small patch a
time. And once you get more familiar with the process you can submit
more, and bigger, patches at a time. Also code cleanup is not really the
best way to start as it's a very subjective matter.

Also try to get more familiar how development is done, here are few
links:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

https://www.kernel.org/doc/Documentation/SubmittingPatches

https://kernelnewbies.org/FirstKernelPatch

Also mailing list archives and git logs are a great way to learn from
how others do it.

-- 
Kalle Valo

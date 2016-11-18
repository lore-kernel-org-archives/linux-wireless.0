Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53876 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbcKRIuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 03:50:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH 0/7] Fix -Wunused-but-set-variable in mwifiex/
Date: Fri, 18 Nov 2016 09:49:53 +0100
Message-ID: <5402325.TthllWe10s@wuerfel> (sfid-20161118_095010_427824_4DD199EB)
In-Reply-To: <cover.1479458373.git.kirtika@google.com>
References: <cover.1479458373.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, November 18, 2016 12:43:22 AM CET Kirtika Ruchandani wrote:
> This patchset is part of the effort led by Arnd Bergmann to clean up
> warnings in the kernel. This and following patchsets will focus on
> "-Wunused-but-set-variable" as it among the noisier ones. These were
> found compiling with W=1.
 
All seven patches look good to me, nice cleanup! 

Acked-by: Arnd Bergmann <arnd@arndb.de>

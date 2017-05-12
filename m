Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757523AbdELIqC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 04:46:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v2 10/11] rsi: Add new firmware loading method
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
        <1494336614-2107-11-git-send-email-amit.karwar@redpinesignals.com>
Date: Fri, 12 May 2017 11:45:57 +0300
In-Reply-To: <1494336614-2107-11-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Tue, 9 May 2017 19:00:13 +0530")
Message-ID: <87lgq2qx8a.fsf@kamboji.qca.qualcomm.com> (sfid-20170512_104609_156966_ED96CBF5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> The older firmware loading method has been deprecated and not in use
> for any chipets. New method is introduced which works based on soft
> boot loader. In this method, complete RAM image and FLASH image are
> present in the flash. Before loading the functional firmware, host
> issues boot loader commands to verify whether firmware to load is
> different from the current functional firmware. If not, firmware
> upgrade progresses and boot loader will switch to the new functional
> firmware.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Please document in the commit log the new firmware filenames used by
this patch.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755879AbdELIq5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 04:46:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v2 11/11] rsi: Remove old firmware loading method
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
        <1494336614-2107-12-git-send-email-amit.karwar@redpinesignals.com>
Date: Fri, 12 May 2017 11:46:50 +0300
In-Reply-To: <1494336614-2107-12-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Tue, 9 May 2017 19:00:14 +0530")
Message-ID: <87h90qqx6t.fsf@kamboji.qca.qualcomm.com> (sfid-20170512_104703_564367_80525633)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> The older firmware loading method is not usable by any Redpine chipset.
> Hence removing that part of the code.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Please document in the commit log the firmware files which are not used
anymore.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932981AbeCMP3e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:29:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 09/10] rsi: tx improvements
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-10-git-send-email-amitkarwar@gmail.com>
Date: Tue, 13 Mar 2018 17:29:29 +0200
In-Reply-To: <1520260620-4694-10-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 5 Mar 2018 20:06:59 +0530")
Message-ID: <87vae0yox2.fsf@purkki.adurom.net> (sfid-20180313_180052_821547_6C5415D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Changes done to improve TX path:
> 1. Max number of frames to aggregate is increased to 8
> 2. Bootup parameters updated.
> 3. registering 5g band is done only when device supports
> 4. Vif is properly taken to enable power save.
> 5. When coex mode exist, power save on by default is set

If you have a list of changes in the commit log to me that's a strong
indication that you need to split the patches.

Also I don't see any answers to question "Why?".

-- 
Kalle Valo

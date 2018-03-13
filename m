Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932498AbeCMP1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:27:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 08/10] rsi: device disconnect changes
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-9-git-send-email-amitkarwar@gmail.com>
Date: Tue, 13 Mar 2018 17:27:50 +0200
In-Reply-To: <1520260620-4694-9-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 5 Mar 2018 20:06:58 +0530")
Message-ID: <87zi3cyozt.fsf@purkki.adurom.net> (sfid-20180313_180638_087683_6F168DA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Below changes are done:
> 1. When HCI detach is called, making bt_adapter null and checking
> for this variable where ever required.
> 2. In USB case, one extra register write is added to disable
> firmware watchdog.
> 3. When interface down is called as part of disconnect, don't
> send RX filter frame.

Why? What does this patch fix? Please explain that (symptoms) in the
commit log.

-- 
Kalle Valo

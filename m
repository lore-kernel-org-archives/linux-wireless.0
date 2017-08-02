Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751142AbdHBJi7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 05:38:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        "pavani.muthyala" <pavani.muthyala@redpinesignals.com>
Subject: Re: [PATCH 1/8] rsi: add support for rf-kill functionality
References: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
        <1501578352-10795-2-git-send-email-amitkarwar@gmail.com>
Date: Wed, 02 Aug 2017 12:38:55 +0300
In-Reply-To: <1501578352-10795-2-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Tue, 1 Aug 2017 14:35:45 +0530")
Message-ID: <87ini648cw.fsf@codeaurora.org> (sfid-20170802_113906_872507_3731C64B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: "pavani.muthyala" <pavani.muthyala@redpinesignals.com>
>
> This patch implements rfkill_poll handler. Also, necessary changes
> are done in interface up and down handler to support rfkill
> functionality.
>
> Signed-off-by: pavani.muthyala <pavani.muthyala@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Pavani's name in From and S-o-b fields are in incorrect format.

-- 
Kalle Valo

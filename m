Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50076 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754889AbcI0LOg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 07:14:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>,
        <yangzy@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>
Subject: Re: [PATCH] cfg80211: add key management offload feature
References: <1474973796-1873-1-git-send-email-akarwar@marvell.com>
Date: Tue, 27 Sep 2016 14:14:31 +0300
In-Reply-To: <1474973796-1873-1-git-send-email-akarwar@marvell.com> (Amitkumar
        Karwar's message of "Tue, 27 Sep 2016 16:26:35 +0530")
Message-ID: <87zimt1tns.fsf@purkki.adurom.net> (sfid-20160927_131440_277841_9B5DF433)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: lihz <lihz@marvell.com>

A minor thing, but the from header in both of the patches don't have the
full name and the git log would look ugly. It should be something like
this:

From: Huazeng Li <lihz@marvell.com>

-- 
Kalle Valo

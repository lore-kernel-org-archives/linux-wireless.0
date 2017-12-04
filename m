Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:41511 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbdLDOXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 09:23:35 -0500
Message-ID: <1512397413.14552.67.camel@sakura.staff.proxad.net> (sfid-20171204_152338_876419_647859D3)
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: akolli@codeaurora.org
Cc: akolli@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Mon, 04 Dec 2017 15:23:33 +0100
In-Reply-To: <45d5ada8ea658e49af85582b4f3f71f7@codeaurora.org>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
         <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
         <1512125137.38490.70.camel@sakura.staff.proxad.net>
         <7792e2fb2c546d8745c65e48945f2535@codeaurora.org>
         <1512140710.38490.81.camel@sakura.staff.proxad.net>
         <45d5ada8ea658e49af85582b4f3f71f7@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2017-12-04 at 18:54 +0530, akolli@codeaurora.org wrote:

> Hope 10.2.4-1.0-00029 Firmware binary works for you.

it does

> I will check this warning.

fixed by applying patch:
 "[PATCH] ath10k: fix recent bandwidth conversion bug"

as suggested by Christian Lamparter

only remaining oddity is the CONFIG_MAC80211_DEBUGFS dependency

-- 
Maxime

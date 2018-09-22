Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51264 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbeIVWSq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 18:18:46 -0400
Subject: Re: [PATCH] mac80211: allocate TXQs for active monitor interfaces
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, cc@80211.de
References: <20180922130953.19581-1-nbd@nbd.name>
Message-ID: <f4f5994d-008d-38af-5a4c-da39fc5f3aa3@nbd.name> (sfid-20180922_182446_646415_BC46216D)
Date: Sat, 22 Sep 2018 18:24:32 +0200
MIME-Version: 1.0
In-Reply-To: <20180922130953.19581-1-nbd@nbd.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-22 15:09, Felix Fietkau wrote:
> Monitor mode interfaces with the active flag are passed down to the driver.
> Drivers using TXQ expect that all interfaces have allocated TXQs before
> they get added.
> 
> Fixes: 79af1f866193d ("mac80211: avoid allocating TXQs that won't be used")
> Cc: stable@vger.kernel.org
> Reported-by: Catrinel Catrinescu <cc@80211.de>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
Sorry, wrong patch. Will resend.

- Felix

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36409 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbeIFOCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:02:31 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Louie Lu <git@louie.lu>, kvalo@codeaurora.org
Cc: ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ath9k: add reset for airtime station debugfs
In-Reply-To: <20180906035323.GA11337@nems_nctu_lu>
References: <20180906035323.GA11337@nems_nctu_lu>
Date: Thu, 06 Sep 2018 11:27:54 +0200
Message-ID: <877ejzynz9.fsf@toke.dk> (sfid-20180906_112801_831569_C7C8F421)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Louie Lu <git@louie.lu> writes:

> Let user can reset station airtime status by debugfs, it will
> reset all airtime deficit to ATH_AIRTIME_QUANTUM and reset rx/tx
> airtime accumulate to 0.

No objections to the patch, but I'm curious which issues you were
debugging that led you to needing it? :)

-Toke

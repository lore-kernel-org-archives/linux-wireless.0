Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49963 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbeIFPOR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 11:14:17 -0400
MIME-Version: 1.0
References: <20180906035323.GA11337@nems_nctu_lu> <877ejzynz9.fsf@toke.dk>
In-Reply-To: <877ejzynz9.fsf@toke.dk>
From: Louie Lu <git@louie.lu>
Date: Thu, 6 Sep 2018 18:41:15 +0800
Message-ID: <CADMDV=yBB-ipz25PWgp+fAdnh0mvqdCcsSzXCp65_SRQqkVBAQ@mail.gmail.com> (sfid-20180906_123934_741540_F3107E7A)
Subject: Re: [PATCH] ath9k: add reset for airtime station debugfs
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous mail rejects by mailing list, re-send again...


Toke Høiland-Jørgensen <toke@toke.dk> 於 2018年9月6日 週四 下午5:27寫道：
>
> Louie Lu <git@louie.lu> writes:
>
> > Let user can reset station airtime status by debugfs, it will
> > reset all airtime deficit to ATH_AIRTIME_QUANTUM and reset rx/tx
> > airtime accumulate to 0.
>
> No objections to the patch, but I'm curious which issues you were
> debugging that led you to needing it? :)
>
I'm testing to get the packet queue time + airtime in ath_tx_process_buffer,
it would be useful if I can reset the station airtime accumulated
value, so I can observe in each test round (e.g. 5 ping) airtime
accumulated

Also to reset the deficit to make sure it runs like fresh one.

Louie.

>
> -Toke

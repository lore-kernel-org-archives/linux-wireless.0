Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:58911 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbdLBJxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 04:53:52 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "akolli\@codeaurora.org" <akolli@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "linux-wireless-owner\@vger.kernel.org"
        <linux-wireless-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
In-Reply-To: <1512143881.25588.18.camel@sipsolutions.net>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com> <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com> <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com> <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk> <87bmjjzppd.fsf@kamboji.qca.qualcomm.com> <5080a68538fd2d883e15bacaa969661b@codeaurora.org> <87r2se36rq.fsf@toke.dk> <87k1y6y04i.fsf@kamboji.qca.qualcomm.com> <87d13y31r0.fsf@toke.dk> <1512143142.25588.17.camel@sipsolutions.net> <87a7z230m3.fsf@toke.dk> <1512143881.25588.18.camel@sipsolutions.net>
Date: Sat, 02 Dec 2017 10:53:48 +0100
Message-ID: <87374t3177.fsf@toke.dk> (sfid-20171202_105356_600489_BF7A9382)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2017-12-01 at 16:54 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> But since we'll have to do that for ath9k anyway it
>> becomes more a question of whether it's something that should be
>> supported in mac80211 or if it should be implemented in each driver.
>> But since that logic will have to be written from scratch anyway, is
>> there any reason to not just do it in mac80211 from the beginning?
>
> I was thinking in the driver so that there's no overhead for the other
> drivers that don't want it that way.
>
> Dunno. It probably doesn't really matter.

I'll prototype something, then we can revisit this based on actual code :)

-Toke

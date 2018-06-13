Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:43373 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935560AbeFMOcJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 10:32:09 -0400
From: Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com>
To: =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Tamizh chelvam" <tamizhr@codeaurora.org>
Subject: RE: [PATCH 0/4] cfg80211/mac80211: Add support to configure and
 monitor txrate threshold
Date: Wed, 13 Jun 2018 14:24:04 +0000
Message-ID: <9fd8762e9d2f4b93b299ab859e389b46@aphydexm01b.ap.qualcomm.com> (sfid-20180613_163213_382010_2F0C3F26)
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
 <87fu1q7uq5.fsf@toke.dk>
In-Reply-To: <87fu1q7uq5.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patchsets introduced new NL command and api to support=20
> configuring txrate threshold for the connected stations and api to=20
> notify userspace application upon crossing the configured txrate threshol=
d.
> This will be useful for the application which requires station's=20
> current capability change information.

What is the intended use case? Asking mostly out of curiosity :)
[Tamizh] This is to monitor txrate change for a station. By notifying users=
pace when the txrate for a station goes out of configured threshold, It can=
 take steering decisions on the particular station.

-Toke

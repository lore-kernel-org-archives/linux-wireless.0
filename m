Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36562 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbcFUOde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 10:33:34 -0400
Received: by mail-ob0-f174.google.com with SMTP id mu6so24577619obc.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 07:33:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160621094146.GA3196@w1.fi>
References: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com>
 <1466470940-25229-1-git-send-email-julian.calaby@gmail.com> <20160621094146.GA3196@w1.fi>
From: Dave Taht <dave.taht@gmail.com>
Date: Tue, 21 Jun 2016 07:25:22 -0700
Message-ID: <CAA93jw4YEEBw+2kd+0MB1R-YHHCeyLRDNZoPVtNrovJG1wy8TA@mail.gmail.com> (sfid-20160621_163340_012900_07DD94A0)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Support 4.9Ghz channels on AR9580 adapter.
To: Jouni Malinen <j@w1.fi>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2016 at 2:41 AM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Jun 21, 2016 at 11:02:20AM +1000, Julian Calaby wrote:
>> I've only done this work as I hate to see people's efforts go to
>> waste and I feel that there's enough roadblocks in the way of
>> actually using this functionality that casual idiots won't be able
>> to.
>
> Are these really ready to go to the upstream kernel in this state and
> without the other changes that would be needed to operate correctly?
> What is the use case for these and how have these been tested?

So far as I know the use case for these is to make it possible to build
open source wifi systems that enable emergency services. This
strikes me as a worthy goal.

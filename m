Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52748 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934768Ab3DOW66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 18:58:58 -0400
Received: by mail-wg0-f44.google.com with SMTP id a12so1816541wgh.11
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 15:58:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130415204030.51f20f43@m4a785t-m.gnutoo.workgroup>
References: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com>
	<20130415204030.51f20f43@m4a785t-m.gnutoo.workgroup>
Date: Mon, 15 Apr 2013 15:58:57 -0700
Message-ID: <CAJ-Vmo=-6yYbX_JnH6bO=ywjHar6SZ+HeCCMhyOSNNS8-j53PA@mail.gmail.com> (sfid-20130416_005901_669474_7DF3E849)
Subject: Re: ath10k: mac80211 driver for QCA9880
From: Adrian Chadd <adrian@freebsd.org>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k-devel@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 April 2013 11:40, Denis 'GNUtoo' Carikli <GNUtoo@no-log.org> wrote:
> Hi,
>
> On Mon, 15 Apr 2013 15:20:54 +0300
> Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>The biggest difference is that there's now firmware running on the
>>chip.
> Will the firmware be released as free software at some point?

There's currently no plans to open source the firmware for ath10k chips.

So it's best to assume the answer is "no".

We'll be sure to tell people if this ever changes.



Adrian

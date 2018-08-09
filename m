Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbeHISML (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 14:12:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: ssb: Remove home-grown printk wrappers
References: <20180731215638.381f0370@wiggum>
Date: Thu, 09 Aug 2018 18:46:38 +0300
In-Reply-To: <20180731215638.381f0370@wiggum> ("Michael \=\?utf-8\?Q\?B\=C3\=BCs\?\=
 \=\?utf-8\?Q\?ch\=22's\?\= message of
        "Tue, 31 Jul 2018 21:56:38 +0200")
Message-ID: <877ekz1r1d.fsf@kamboji.qca.qualcomm.com> (sfid-20180809_174645_354109_64656470)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael B=C3=BCsch <m@bues.ch> writes:

> Replace the ssb printk wrappers by standard print helpers.
> Also remove SSB_SILENT. Nobody should use it anyway.
>
> Originally submitted by Joe Perches <joe@perches.com>.
> Modified to add dev_... based printks.
>
> Signed-off-by: Michael Buesch <m@bues.ch>
> Tested-by: Michael Buesch <m@bues.ch>
> Cc: Joe Perches <joe@perches.com>

Applied manually:

4d77a89e3924 b43legacy/leds: Ensure NUL-termination of LED name string

--=20
Kalle Valo

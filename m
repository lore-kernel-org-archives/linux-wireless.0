Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26821 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752645AbdJLD6F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 23:58:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Brian Norris <briannorris@chromium.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grant Grundler" <grundler@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: fix core PCI suspend when WoWLAN is supported but
 disabled
Date: Thu, 12 Oct 2017 03:58:00 +0000
Message-ID: <87y3ohow54.fsf@kamboji.qca.qualcomm.com> (sfid-20171012_055842_649349_D31AF7F7)
References: <20170919232416.108247-1-briannorris@chromium.org>
        <20171012003805.GA89253@google.com>
In-Reply-To: <20171012003805.GA89253@google.com> (Brian Norris's message of
        "Wed, 11 Oct 2017 17:38:06 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> Ping? Any comments? I know there's more than one way to slice this
> problem, but it's most definitely a problem...

I'm lagging behind with patches but I'll try to catch up this week.
Sorry.

--=20
Kalle Valo=

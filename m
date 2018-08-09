Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48216 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732163AbeHISK4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 14:10:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        =?utf-8?Q?Rafa=C5=82_Mi?= =?utf-8?Q?=C5=82ecki?=
        <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43legacy/leds: Ensure NUL-termination of LED name string
References: <20180731211416.36cde729@wiggum>
Date: Thu, 09 Aug 2018 18:45:22 +0300
In-Reply-To: <20180731211416.36cde729@wiggum> ("Michael \=\?utf-8\?Q\?B\=C3\=BCs\?\=
 \=\?utf-8\?Q\?ch\=22's\?\= message of
        "Tue, 31 Jul 2018 21:14:16 +0200")
Message-ID: <87bmab1r3h.fsf@kamboji.qca.qualcomm.com> (sfid-20180809_174530_218348_30968302)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael B=C3=BCsch <m@bues.ch> writes:

> strncpy might not NUL-terminate the string, if the name equals the buffer=
 size.
> Use strlcpy instead.
>
> Signed-off-by: Michael Buesch <m@bues.ch>
> Cc: stable@vger.kernel.org

Applied manually:

4d77a89e3924 b43legacy/leds: Ensure NUL-termination of LED name string

--=20
Kalle Valo

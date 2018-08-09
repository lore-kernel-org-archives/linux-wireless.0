Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730880AbeHISOi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 14:14:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        Joe Perches <joe@perches.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: ssb: Remove SSB_WARN_ON, SSB_BUG_ON and SSB_DEBUG
References: <20180731221509.59c0a17a@wiggum>
Date: Thu, 09 Aug 2018 18:49:02 +0300
In-Reply-To: <20180731221509.59c0a17a@wiggum> ("Michael \=\?utf-8\?Q\?B\=C3\=BCs\?\=
 \=\?utf-8\?Q\?ch\=22's\?\= message of
        "Tue, 31 Jul 2018 22:15:09 +0200")
Message-ID: <8736vn1qxd.fsf@kamboji.qca.qualcomm.com> (sfid-20180809_174911_163172_4FE4CB6C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael B=C3=BCsch <m@bues.ch> writes:

> Use the standard WARN_ON instead.
> If a small kernel is desired, WARN_ON can be disabled globally.
>
> Also remove SSB_DEBUG. Besides WARN_ON it only adds a tiny debug check.
> Include this check unconditionally.
>
> Signed-off-by: Michael Buesch <m@bues.ch>

Applied manually:

209b43759d65 ssb: Remove SSB_WARN_ON, SSB_BUG_ON and SSB_DEBUG

--=20
Kalle Valo

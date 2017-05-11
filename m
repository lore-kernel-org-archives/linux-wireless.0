Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27245 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbdEKDzd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 23:55:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Su Kang Yin <paradyse@gmail.com>
CC: Adrian Chadd <adrian@freebsd.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] [ath10k] go back to using dma_alloc_coherent() for
 firmware scratch memory.
Date: Thu, 11 May 2017 03:55:25 +0000
Message-ID: <87bmr0vyhe.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_055543_244407_333BCF82)
References: <20170501214327.5621-1-adrian@freebsd.org>
        <CAHjFwoAr6Tjh=Zpr_JhEp_-g_0XJ+LDUagsfJh=vqseqzBC1Pw@mail.gmail.com>
In-Reply-To: <CAHjFwoAr6Tjh=Zpr_JhEp_-g_0XJ+LDUagsfJh=vqseqzBC1Pw@mail.gmail.com>       (Su Kang
 Yin's message of "Thu, 11 May 2017 01:21:06 +0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Su Kang Yin <paradyse@gmail.com> writes:

> Without this patch QCA9888 is not working. Also I have to update
> board2.bin from Kalle's git repo.

More details would be good to know, as the behaviour seems to vary quite
a lot. What platform are you using, x86, some ARM board or what? And
what kernel exactly?

--=20
Kalle Valo=

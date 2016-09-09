Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31077 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752567AbcIIMgB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:36:01 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: support for QCA9377 SDIO (ath10k or ath6kl)
Date: Fri, 9 Sep 2016 12:35:55 +0000
Message-ID: <87wpilp7x0.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_143604_970652_DE75A8E9)
References: <CAFBinCDnmEuSEKofHQy3SkKuewL+cjuxhibj7O71ASL0yfH_Ew@mail.gmail.com>
In-Reply-To: <CAFBinCDnmEuSEKofHQy3SkKuewL+cjuxhibj7O71ASL0yfH_Ew@mail.gmail.com>       (Martin
 Blumenstingl's message of "Thu, 8 Sep 2016 21:31:12 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> is there any support for the SDIO chips QCA9377 (and QCA9378) planned?
> Would these be supported by ath10k or ath6kl or is a completely new
> driver needed?

I'm not familiar with the details of QCA9377 SDIO firmware but I assume
ath10k would be the best option for supporting it. We split from the
beginning the core code (ath10k_core.ko) and the PCI code
(ath10k_pci.ko) to make it easier to add new bus support.

--=20
Kalle Valo=

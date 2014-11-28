Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39985 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaK1HKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 02:10:31 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: embed supported chip ids in hw_params
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	<87vbm2whoz.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=56six2CEQ6Rzr7yMEM7UVNQ3RX9UpdgmxMEoG0+kDAA@mail.gmail.com>
Date: Fri, 28 Nov 2014 09:10:12 +0200
In-Reply-To: <CA+BoTQ=56six2CEQ6Rzr7yMEM7UVNQ3RX9UpdgmxMEoG0+kDAA@mail.gmail.com>
	(Michal Kazior's message of "Wed, 26 Nov 2014 08:54:30 +0100")
Message-ID: <87d287u7fv.fsf@kamboji.qca.qualcomm.com> (sfid-20141128_081051_972537_D8454D8D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hmm.. I have a couple of ideas:

[...]

> 2. Have a dedicatd pci-specific structure:
>
>  struct ath10k_pci_supported_chip {
>    u16 dev_id;
>    u32 chip_id;
>  };
>
>  struct ath10k_pci_supported_chip ath10k_pci_supported_chips[] = {
>    { QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
>    // ...
>  };
>
> Probably the simplest and has least impact.

Yeah, this seems to be the best. Can you send v2?

-- 
Kalle Valo

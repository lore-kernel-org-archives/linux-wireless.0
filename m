Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35414 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaCYIyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:54:06 -0400
Received: by mail-vc0-f182.google.com with SMTP id ks9so170283vcb.13
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 01:54:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQn4ji2boTV8x-owO8PbaPm510wYEKmbKqf+VS+MS+DXnQ@mail.gmail.com>
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
	<CAEFj9867Z+x3orcwUpwjwQB-9c5r4FfAuZBHYDGZ1hNe=6Z1pA@mail.gmail.com>
	<CA+BoTQn4ji2boTV8x-owO8PbaPm510wYEKmbKqf+VS+MS+DXnQ@mail.gmail.com>
Date: Tue, 25 Mar 2014 16:54:06 +0800
Message-ID: <CAEFj9854WN5qJ4L4V1vkLeGhj=pstjoha19iJMQ8Vy-g24a66A@mail.gmail.com> (sfid-20140325_095414_864387_ACABE8A4)
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>> BTW, I also saw that the same happen to latest AP firmware whenever
>> the peer stats is more than 1. But since the first peer stats is self
>> stats, so it is ok to overwrite it.
>
> I disagree. Why do you think it is okay to overwrite self peer stats?
>
Because TxRate, RxRate, RSSI are all no value, just the MAC address.

> Btw. 10.1 firmware has more pdev stats which breaks parsing of peer entries...

Yes, let me investigate further.

-----
Chun-Yeow

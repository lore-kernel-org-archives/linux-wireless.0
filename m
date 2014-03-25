Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53135 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaCYI5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:57:11 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so179548oag.28
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 01:57:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj9854WN5qJ4L4V1vkLeGhj=pstjoha19iJMQ8Vy-g24a66A@mail.gmail.com>
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
	<CAEFj9867Z+x3orcwUpwjwQB-9c5r4FfAuZBHYDGZ1hNe=6Z1pA@mail.gmail.com>
	<CA+BoTQn4ji2boTV8x-owO8PbaPm510wYEKmbKqf+VS+MS+DXnQ@mail.gmail.com>
	<CAEFj9854WN5qJ4L4V1vkLeGhj=pstjoha19iJMQ8Vy-g24a66A@mail.gmail.com>
Date: Tue, 25 Mar 2014 09:57:10 +0100
Message-ID: <CA+BoTQmNVHj-rNvVgvTx=Adq6J1kpra2qwi3Pmzh2G2Npn-jGg@mail.gmail.com> (sfid-20140325_095720_129772_336D04A6)
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
From: Michal Kazior <michal.kazior@tieto.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2014 09:54, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>>
>>> BTW, I also saw that the same happen to latest AP firmware whenever
>>> the peer stats is more than 1. But since the first peer stats is self
>>> stats, so it is ok to overwrite it.
>>
>> I disagree. Why do you think it is okay to overwrite self peer stats?
>>
> Because TxRate, RxRate, RSSI are all no value, just the MAC address.

I don't think that's true for 10.1 firmware and AP interface types.


Michał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37206 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdEVG1m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 02:27:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Daniel Drake <drake@endlessm.com>
CC: qca_merez <qca_merez@qca.qualcomm.com>,
        wil6210 <wil6210@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Chris Chiu <chiu@endlessm.com>
Subject: Re: Where is wil6210.fw / wil6210.brd?
Date: Mon, 22 May 2017 06:27:35 +0000
Message-ID: <87fufxv22b.fsf@kamboji.qca.qualcomm.com> (sfid-20170522_082746_661035_247BAFF6)
References: <CAD8Lp45k01+rN8RXdvPthEDeJj7p-a-Lk5A1AQWXJBGezxQpaA@mail.gmail.com>
        <878tny7sdx.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878tny7sdx.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Tue, 21 Mar 2017 13:59:06 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Daniel Drake <drake@endlessm.com> writes:
>
>> We are working with a new consumer laptop model that includes a
>> wil6210 wireless adapter.
>>
>> It is not usable on current Linux distros because the firmware is not
>> present. It's not in linux-firmware and we can't even find any
>> download links when searching the web.
>>
>> Could you please send a copy of the required firmware to linux-firmware?
>> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.=
git
>
> I asked internally about the status of the firmware release and we are
> working on it. Naturally I can't give any promises when it will be
> available, but hopefully soon.

Maya now submitted the firmware to linux-firmware:

http://lkml.kernel.org/r/1495370937-5369-1-git-send-email-qca_merez@qca.qua=
lcomm.com

--=20
Kalle Valo=

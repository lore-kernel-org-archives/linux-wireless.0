Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:33250 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdCNVzI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 17:55:08 -0400
Received: by mail-ot0-f176.google.com with SMTP id 19so152050174oti.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 14:55:08 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Drake <drake@endlessm.com>
Date: Tue, 14 Mar 2017 15:55:07 -0600
Message-ID: <CAD8Lp45k01+rN8RXdvPthEDeJj7p-a-Lk5A1AQWXJBGezxQpaA@mail.gmail.com> (sfid-20170314_225511_779616_6CBBF4D6)
Subject: Where is wil6210.fw / wil6210.brd?
To: qca_merez@qca.qualcomm.com, wil6210@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>,
        Chris Chiu <chiu@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are working with a new consumer laptop model that includes a
wil6210 wireless adapter.

It is not usable on current Linux distros because the firmware is not
present. It's not in linux-firmware and we can't even find any
download links when searching the web.

Could you please send a copy of the required firmware to linux-firmware?
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

Thanks
Daniel

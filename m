Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:39508 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755893AbeARKyB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 05:54:01 -0500
Received: by mail-it0-f45.google.com with SMTP id 68so13079878ite.4
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 02:54:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3Vij4AeiWuOyi5XFiiAF5nqQERR8tDyrRoKZMLFmKoQw@mail.gmail.com>
References: <CAMNDV2kK33fWYVNNAO8=ZqgxyPdXxTdOrxdQnW6ORMFM1hkrxQ@mail.gmail.com>
 <CANUX_P3Vij4AeiWuOyi5XFiiAF5nqQERR8tDyrRoKZMLFmKoQw@mail.gmail.com>
From: Tambet Arak <tambet.arak@gmail.com>
Date: Thu, 18 Jan 2018 12:54:00 +0200
Message-ID: <CAMNDV2=GqLDnxJfk=0+WC25jK-G=SYZL7PAEMZsUT4W5SAEzzg@mail.gmail.com> (sfid-20180118_115404_767940_EF4AA99A)
Subject: Re: A few questions about iwlwifi and its rate control mechanism
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see. I might try playing around with hacking iwl-agn-rs, in that case.

> What do you mean by 'drop'. Disassociated? Or associated but no traffic?
> Association state can be checked with iw <iface> link

Sorry, that was ambiguous. I meant that the rate is decreased to e.g. MCS3-5.

Tambet

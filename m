Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36004 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdGYWze (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 18:55:34 -0400
Received: by mail-pg0-f48.google.com with SMTP id 125so75980157pgi.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2017 15:55:34 -0700 (PDT)
MIME-Version: 1.0
From: Jacob Bower <jacob.bower@gmail.com>
Date: Tue, 25 Jul 2017 15:55:13 -0700
Message-ID: <CAHWWEcbBiTChDns8XaXmG7p8FiFqxzN3-No2J+Lvmt4yYKLi2g@mail.gmail.com> (sfid-20170726_005538_402898_0C982CFD)
Subject: New binary blobs for BCM43xxx devices?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

If understand correctly CVE-2017-9417 (aka. the "broadpwn" exploit) is
addressed by firmware updates in new drivers recently released by some
major vendors.

Is there a systematic way to extract the new firmware to help secure
Linux systems with BCM43xxx devices?

In my specific case I have a MacBook Pro 12.1 with a BCM43602 running
Linux and the brcmfmac driver, but have an old partition with OS X. I
was hoping it might be possible to extract the firmware from the
latest OS X updates? Or, maybe there is a way to get the latest
release of Linux drivers from Broadcom and extract from there? (I had
a bit of trouble figuring out if there is a specific Broadcom page for
the latest version of their restrictively licensed drivers).

I appreciate this could be a contentious issue and apologise in
advance if this is the wrong forum for this discussion.

Kind regards,
Jacob

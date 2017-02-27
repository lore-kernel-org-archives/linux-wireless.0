Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbdB0L5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 06:57:17 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH 0/4] brcmfmac: Remove a bunch of false positive error logs
Date: Mon, 27 Feb 2017 11:01:36 +0100
Message-Id: <20170227100140.5190-1-hdegoede@redhat.com> (sfid-20170227_125758_004639_AC752BD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

Here is a small series to stop brcmfmac from spamming dmesg with errors
which are not really errors at all.

Note the 4th patch actually contains a small behavior change rather then
just changing logging, so it needs a bit of extra review attention.

Regards,

Hans

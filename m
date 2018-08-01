Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbeHAJYX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 05:24:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 00/14] Add mt76x0 driver
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
Date: Wed, 01 Aug 2018 10:39:58 +0300
In-Reply-To: <1533040864-9026-1-git-send-email-sgruszka@redhat.com> (Stanislaw
        Gruszka's message of "Tue, 31 Jul 2018 14:40:50 +0200")
Message-ID: <87y3dqzga9.fsf@purkki.adurom.net> (sfid-20180801_094238_379913_FF1AEF08)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> Add mt76x0 driver for MT7610U based USB dongles. Currently driver
> support only STA mode.
>
> mt76x0 is based on Jakub's mt7601u driver already included
> in the kernel. I would like the driver be integrated as part
> of mt76 (instead of separate driver in mediatek dir like mt7601u)
> to utilize mt76 code for adding support for MT76x0 PCIe devices
> in further development.

So what's the future for mt7601u, are we going to delete it? What's
Jakub's opinion about all this? And what's the delta featurewise between
mt7601u and this driver? Which one will be loaded by default?

Also I noticed that mt76 is missing an entry in MAINTAINERS file? Could
someone send a separate patch to add that, please?

-- 
Kalle Valo

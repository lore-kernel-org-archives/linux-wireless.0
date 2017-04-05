Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11940 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932586AbdDEKJv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 06:09:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alban <albeu@free.fr>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        John Crispin <john@phrozen.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] Documentation: dt: net: Update the ath9k binding for
 SoC devices
Date: Wed, 5 Apr 2017 10:09:44 +0000
Message-ID: <87tw63i2s7.fsf@kamboji.qca.qualcomm.com> (sfid-20170405_121101_861216_49C1F6CC)
References: <1489439116-4233-1-git-send-email-albeu@free.fr>
In-Reply-To: <1489439116-4233-1-git-send-email-albeu@free.fr> (Alban's message
        of "Mon, 13 Mar 2017 22:05:09 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alban <albeu@free.fr> writes:

> The current binding only cover PCI devices so extend it for SoC devices.
>
> Most SoC platforms use an MTD partition for the calibration data
> instead of an EEPROM. The qca,no-eeprom property was added to allow
> loading the EEPROM content using firmware loading. This new binding
> replace this hack with NVMEM cells, so we also mark the qca,no-eeprom
> property as deprecated in case anyone ever used it.

A patchset like this should definitely have a cover letter and explain
the backround and reasoning for this patchset. Currently I'm just
guessing.

> Signed-off-by: Alban <albeu@free.fr>

Please use your full name both in From and S-o-b lines.

--=20
Kalle Valo=

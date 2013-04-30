Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:32845 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760624Ab3D3SCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 14:02:25 -0400
Received: by mail-we0-f175.google.com with SMTP id i48so678084wef.34
        for <linux-wireless@vger.kernel.org>; Tue, 30 Apr 2013 11:02:24 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Apr 2013 11:02:22 -0700
Message-ID: <CAJ-Vmon50nyvxJyV1J9XTqNDOb1+EbneqkxdkX7H=Nks+JJy+w@mail.gmail.com> (sfid-20130430_200232_416681_3302E7DF)
Subject: Announcement: AR5513 HAL
From: Adrian Chadd <adrian@freebsd.org>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've just pushed a copy of the AR5513 HAL from Qualcomm Atheros into
the QCA github repository.

https://github.com/qca/qca-ar5513-hal

The AR5513 is a 2-antenna MIMO 11abg (not 11n) device that was sold
into a few markets. As far as I'm aware, it's the only legacy PCI(e)
chipset which the open source Atheros drivers are missing support for.

The HAL is from an earlier development effort, before things had fully
migrated to using a Madwifi derivative. Thus, the HAL API isn't
(easily) compatible with the Madwifi or FreeBSD Atheros driver code.
However, it should be sufficient to bring up chipset support for the
AR5513 in ath5k.

We've opened this up in the hope that the opensource crowd will add
support to ath5k for this chipset.

Thanks,



Adrian

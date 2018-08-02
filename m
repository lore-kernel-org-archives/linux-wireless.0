Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeHBUo6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 16:44:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v3 01/14] mt76x0: core files
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533040864-9026-2-git-send-email-sgruszka@redhat.com>
References: <1533040864-9026-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20180802185234.D5C5B600ED@smtp.codeaurora.org> (sfid-20180802_205238_257881_0E5A5BFE)
Date: Thu,  2 Aug 2018 18:52:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Core files of mt76x0 driver.
> 
> mt76x0 driver adds support for Mediatek MT7610U based
> USB Wi-Fi dongles.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

14 patches applied to wireless-drivers-next.git, thanks.

7b4859026ccd mt76x0: core files
a77443498137 mt76x0: mac files
ff69c75ee539 mt76x0: usb files
55b13a047445 mt76x0: mcu files
10de7a8b4ab9 mt76x0: phy files
134b2d0d1fcf mt76x0: init files
e87b5039511a mt76x0: eeprom files
a79e4638152f mt76x0: trace and debugfs files
b4d4d0644331 mt76x0: dma and tx files
95e444098a7b mt76x0: main file
87e022de330a mt76: add more states
52abb142baa0 mt76: Kconfig and Makefile for mt76x0 driver
369bbecdbb2d mt76x0: disable HW before probe
a33ce21e2afc mt76x0: load firmware from mediatek subdir

-- 
https://patchwork.kernel.org/patch/10550731/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

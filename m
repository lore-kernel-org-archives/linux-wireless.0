Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34887 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbHPPKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 11:10:34 -0400
Received: by iodt126 with SMTP id t126so127830064iod.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2015 08:10:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439708139-7527-1-git-send-email-arend@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
Date: Sun, 16 Aug 2015 17:10:34 +0200
Message-ID: <CACna6rxgTFan=xfidvfzFVRLBuJOWtDCyWe-unc-VeETrU_JQA@mail.gmail.com> (sfid-20150816_171050_267487_DEE28408)
Subject: Re: [PATCH V2 0/7] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
> This series comprises of following changes:
> - support NVRAM loading for bcm47xx platform.
> - revise announced interface combinations and validate against it.
> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
> - couple of PCIe fixes.
> - support more firmware events (for bcm4339 firmware).
>
> The series is intended for v4.3 kernel and applies to the master branch
> of the wireless-drivers-next repository.

Thanks! I'll be happy to test it with BCM43602 for regressions in 3-4
days if you can wait that much.

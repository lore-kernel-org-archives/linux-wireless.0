Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36853 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbcAYXYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 18:24:01 -0500
Received: by mail-io0-f178.google.com with SMTP id g73so172333863ioe.3
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2016 15:24:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453712816-2343-1-git-send-email-arend@broadcom.com>
References: <1453712816-2343-1-git-send-email-arend@broadcom.com>
Date: Tue, 26 Jan 2016 00:24:00 +0100
Message-ID: <CACna6rwQz3ES=CopxJNshX9iWgc4PCOqQeVr0WeJo3E=ST1Dqg@mail.gmail.com> (sfid-20160126_002405_333861_684C6D62)
Subject: Re: [PATCH] brcm: add firmware for bcm4366 device
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-firmware@kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 January 2016 at 10:06, Arend van Spriel <arend@broadcom.com> wrote:
> This patch adds firmware for the bcm4366 11ac wlan device which
> is supported by the brcmfmac driver since commit 55acca90da52
> ("brcmfmac: Add support for the BCM4365 and BCM4366 PCIE devices").

Thanks a lot for releasing it so quickly since my report!

Unfrotunately there is some problem with this firmware or brcmfmac
driver. I tried the latest brcmfmac + added 14e4:4365 support on my
D-Link DIR-885L and got this:
[   52.853422] brcmfmac: brcmf_pcie_download_fw_nvram: FW failed to initialize
any hint what could cause this problem?

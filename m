Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33081 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbH0OVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 10:21:23 -0400
Received: by iods203 with SMTP id s203so58625490iod.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 07:21:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440684846-17214-1-git-send-email-arend@broadcom.com>
References: <1440684846-17214-1-git-send-email-arend@broadcom.com>
Date: Thu, 27 Aug 2015 16:21:22 +0200
Message-ID: <CACna6rxaQE=LZ-vWzxidnsD7UkGjtV13m4GDnvH7R9MsfVk6UA@mail.gmail.com> (sfid-20150827_162133_630219_453570A0)
Subject: Re: [PATCH] brcmfmac: Reset PCIE devices after recognition.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2015 at 16:14, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> When PCIE type devices are being FW reloaded without being properly
> reset then the device ends up in a locked state, requiring the
> device to be completely powered down. This patch adds a reset
> through watchdog at the moment the device (cores) has been
> recognized. This will solve warm reboot issues.
>
> Cc: Rafal Milecki <zajec5@gmail.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Kalle,
>
> One more patch (probably for 4.4) which has been tested by
> Rafal. The post is mainly to make the patch publicly available
> for him to use in OpenWrt.

Thank you, I appreciate that!

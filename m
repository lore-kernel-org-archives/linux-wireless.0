Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38237 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934279AbbDXI6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 04:58:46 -0400
Received: by igbhj9 with SMTP id hj9so9606191igb.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2015 01:58:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429035033-14076-11-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-11-git-send-email-arend@broadcom.com>
Date: Fri, 24 Apr 2015 10:58:45 +0200
Message-ID: <CACna6rzpRmNCNafi5vk1an2FC+fky+Zm4EJbFASw-cE1oRvBjA@mail.gmail.com> (sfid-20150424_105850_351414_9E3D9B15)
Subject: Re: [PATCH 10/10] brcmfmac: Add support for multiple PCIE devices in nvram.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 April 2015 at 20:10, Arend van Spriel <arend@broadcom.com> wrote:
> +int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
> +                          const char *code, const char *nvram,
> +                          void (*fw_cb)(struct device *dev,
> +                                        const struct firmware *fw,
> +                                        void *nvram_image, u32 nvram_len))
> +{
> +       return brcmf_fw_get_firmwares_pcie(dev, flags, code, nvram, fw_cb, 0,
> +                                          0);
> +}
> +

git complains about adding an extra (2nd) empty line at EOF

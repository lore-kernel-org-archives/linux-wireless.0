Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37700 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1FFLeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:34:16 -0400
Received: by qwk3 with SMTP id 3so1596789qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 04:34:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307311658-15853-8-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-8-git-send-email-hauke@hauke-m.de>
Date: Mon, 6 Jun 2011 13:34:15 +0200
Message-ID: <BANLkTi=6F_T1vwJL3e0DMbKhuFjjnF5pAQ@mail.gmail.com> (sfid-20110606_133420_208742_52FFDE0A)
Subject: Re: [RFC][PATCH 07/10] bcma: add pci(e) host mode
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> +#ifdef CONFIG_BCMA_PCICORE_HOSTMODE
> +/* driver_pci_host.c */
> +extern int bcma_pcicore_is_in_hostmode(struct bcma_drv_pci *pc);
> +extern void bcma_pcicore_init_hostmode(struct bcma_drv_pci *pc);
> +#endif /* CONFIG_BCMA_PCICORE_HOSTMODE */

I don't know if I'm overreacting, but I really don't like naming mess
in the ssb.

Why don't you use bcma_core_pci_* to be consistent?

-- 
Rafał

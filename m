Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40344 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab2IKXg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 19:36:59 -0400
Received: by lagy9 with SMTP id y9so708862lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 16:36:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347004574-80506-1-git-send-email-nbd@openwrt.org>
References: <1347004574-80506-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 11 Sep 2012 16:36:38 -0700
Message-ID: <CAB=NE6Ve4fwqx0DQiA1Rrf=w9h4aqbKa1+MdYMtj3_m4xPW5xA@mail.gmail.com> (sfid-20120912_013706_027334_0EE5C94F)
Subject: Re: [PATCH] compat: drop const to fix compiler warnings
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 7, 2012 at 12:56 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> When calling pci_find_capability and pci_read_config_word, struct pci_dev
> needs to be passed without const.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Applied and pushed, thanks!

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58313 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758104Ab2IGJE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 05:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <1347004574-80506-1-git-send-email-nbd@openwrt.org>
References: <1347004574-80506-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 7 Sep 2012 02:04:37 -0700
Message-ID: <CAB=NE6V6vAdsVQyjKyaMYnPRQdJLc+Gt=nqiS5cN9mWU3vz7aQ@mail.gmail.com> (sfid-20120907_110519_009116_E8AE40D7)
Subject: Re: [PATCH] compat: drop const to fix compiler warnings
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 7, 2012 at 12:56 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> When calling pci_find_capability and pci_read_config_word, struct pci_dev
> needs to be passed without const.

Thanks! I guess because at certain kernel version pci_dev was const ?

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3734 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab2INQAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 12:00:49 -0400
Message-ID: <505354AC.7040108@broadcom.com> (sfid-20120914_180100_301211_116BEB47)
Date: Fri, 14 Sep 2012 18:00:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Fengguang Wu" <fengguang.wu@intel.com>
cc: "Hante Meuleman" <meuleman@broadcom.com>,
	kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [iwlwifi:master 67/70]
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:732:42: sparse:
 invalid assignment: |=
References: <20120914144351.GA23614@localhost>
In-Reply-To: <20120914144351.GA23614@localhost>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2012 04:43 PM, Fengguang Wu wrote:
> Hi Hante,
>
> FYI, there are new sparse warnings show up in
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git master
> head:   99f314c04ff5f4cfd969f5fbe82d6d0c0a7d8336
> commit: e756af5b30b008f6ffcfebf8ad0b477f6f225b62 [67/70] brcmfmac: add e-scan support.
>
> All sparse warnings:

Thanks, Fengguang

I was doing 'make C=2' today and noticed these warnings as well. Already 
patching it.

Regards,
Arend


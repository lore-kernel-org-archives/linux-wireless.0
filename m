Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43814 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaBRRY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 12:24:59 -0500
Message-ID: <53039767.1060907@broadcom.com> (sfid-20140218_182534_891027_0A878CC9)
Date: Tue, 18 Feb 2014 18:24:55 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Denys Vlasenko <dvlasenk@redhat.com>
CC: Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c:
 deinline brcmf_sdio_chip_cr4_enterdl, save 440 bytes
References: <1392732320-18973-1-git-send-email-dvlasenk@redhat.com> <1392732925.22752.26.camel@joe-AO722>
In-Reply-To: <1392732925.22752.26.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2014 03:15 PM, Joe Perches wrote:
> On Tue, 2014-02-18 at 15:05 +0100, Denys Vlasenko wrote:
>> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> 
> Hi Denys
> 
> Perhaps these patch subjects would be better without
> the file path, but shortened to something like:
> 
> brcmfmac: sdio_chip: deinline function to reduce object size

Indeed, only the driver name prefix is nice to have so

brcmfmac: deinline <func_name> to reduce object size

Given that you are updating sdio_chip.c makes me conclude that you did
not make these changes in the wireless-next repository. Can you please
resubmit them for wireless-next/master.

Regards,
Arend


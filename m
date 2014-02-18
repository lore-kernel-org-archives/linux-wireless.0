Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:54344 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755341AbaBROP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 09:15:27 -0500
Message-ID: <1392732925.22752.26.camel@joe-AO722> (sfid-20140218_151558_391324_4C34AE9E)
Subject: Re: [PATCH] drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c:
 deinline brcmf_sdio_chip_cr4_enterdl, save 440 bytes
From: Joe Perches <joe@perches.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 18 Feb 2014 06:15:25 -0800
In-Reply-To: <1392732320-18973-1-git-send-email-dvlasenk@redhat.com>
References: <1392732320-18973-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-18 at 15:05 +0100, Denys Vlasenko wrote:
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Hi Denys

Perhaps these patch subjects would be better without
the file path, but shortened to something like:

brcmfmac: sdio_chip: deinline function to reduce object size



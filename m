Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3KZO0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 09:26:22 -0500
Message-ID: <1385475973.4177.1.camel@jlt4.sipsolutions.net> (sfid-20131126_152631_738556_FDB6761B)
Subject: Re: invalid sparse warnings ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Nov 2013 15:26:13 +0100
In-Reply-To: <5294AE3F.3090901@broadcom.com> (sfid-20131126_152109_226540_16C4AA96)
References: <5294AE3F.3090901@broadcom.com>
	 (sfid-20131126_152109_226540_16C4AA96)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-26 at 15:20 +0100, Arend van Spriel wrote:
> Does some of you get these possibly invalid sparse warnings since 3.13-rc1?
> 
> brcm80211/brcmfmac/bcmsdh.c:777:1: warning: symbol 
> '__ksymtab_brcmf_sdio_probe' was not declared. Should it be static?
> 
> The function brcmf_sdio_probe() is exported using EXPORT_SYMBOL macro. 
> Maybe upgrade my sparse installment?

See the sparse mailing list,
http://www.spinics.net/lists/linux-sparse/msg03297.html

johannes


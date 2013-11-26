Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2003 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab3KZOVF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 09:21:05 -0500
Received: from [10.176.68.141] (unknown [10.176.68.141]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id 940A0207C4 for
 <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 06:20:48 -0800 (PST)
Message-ID: <5294AE3F.3090901@broadcom.com> (sfid-20131126_152109_226540_16C4AA96)
Date: Tue, 26 Nov 2013 15:20:47 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: invalid sparse warnings ?
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does some of you get these possibly invalid sparse warnings since 3.13-rc1?

brcm80211/brcmfmac/bcmsdh.c:777:1: warning: symbol 
'__ksymtab_brcmf_sdio_probe' was not declared. Should it be static?

The function brcmf_sdio_probe() is exported using EXPORT_SYMBOL macro. 
Maybe upgrade my sparse installment?

Regards,
Arend


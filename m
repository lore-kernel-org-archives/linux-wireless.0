Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5601 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab2ARLtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 06:49:22 -0500
Message-ID: <4F16B1B3.3030209@qca.qualcomm.com> (sfid-20120118_124925_571247_E497A68E)
Date: Wed, 18 Jan 2012 13:49:07 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Alex Yang <xiaojuny@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] Add testmode 2 for 6003 ART.
References: <1326807149-3809-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1326807149-3809-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2012 03:32 PM, Kalle Valo wrote:
> From: Alex Yang <xiaojuny@qca.qualcomm.com>
> 
> Add testmode 2 for 6003 ART. When you insmod ath6kl_sdio.ko
> testmode=2, ath6kl will load ART firmware utf.bin and testscript
> nullTestFlow.bin. These files should be put in the firmware folder.
> 
> Signed-off-by: Alex Yang <xiaojuny@qca.qualcomm.com> --- 

Thanks, applied with following changes:

   kvalo: add "ath6kl:" to the title, word wrap the commit log and remove
    extra line in the code

Kalle

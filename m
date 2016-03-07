Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27474 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcCGMGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:06:00 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: qca_merez <qca_merez@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH v2 00/15] wil6210 patches
Date: Mon, 7 Mar 2016 12:05:54 +0000
Message-ID: <87twkitrvu.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_130605_099491_B0D32F06)
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Tue, 1 Mar 2016 19:18:03 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> Changes in V2:
> - Fixed oob_mode module parameter description
>
> This set of patches includes:
> - wil6210 bug fixes
> - P2P support
> - switch to generated wmi.h
> - replay attack detection
>
> Dedy Lansky (1):
>   wil6210: p2p initial support
>
> Hamad Kadmany (1):
>   wil6210: Set permanent MAC address to wiphy
>
> Lior David (9):
>   wil6210: add support for discovery mode during scan
>   wil6210: switch to generated wmi.h
>   wil6210: basic PBSS/PCP support
>   wil6210: P2P_DEVICE virtual interface support
>   wil6210: fix race conditions in p2p listen and search
>   wil6210: clean ioctl debug message
>   wil6210: fix no_fw_recovery mode with change_virtual_intf
>   wil6210: pass is_go flag to firmware
>   wil6210: add oob_mode module parameter
>
> Maya Erez (3):
>   wil6210: remove BACK RX and TX workers
>   wil6210: AP: prevent connecting to already connected station
>   wil6210: add support for platform specific notification events
>
> Vladimir Kondratiev (1):
>   wil6210: replay attack detection

All 15 applied to ath.git, thanks.

-- 
Kalle Valo
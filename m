Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44353 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbcECKH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 06:07:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/11] rtl8xxxu: Rename rtl8xxxu.c to rtl8xxxu_core.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461871155-11826-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160503100755.404106130F@smtp.codeaurora.org> (sfid-20160503_120814_384009_E6593576)
Date: Tue,  3 May 2016 10:07:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This renames the core file to rtl8xxxu_core.c in order to allow us to
> keep the module nake rtl8xxxu.ko when refactoring the code into
> multiple files.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 11 patches applied to wireless-drivers-next.git:

6c60e65cd092 rtl8xxxu: Rename rtl8xxxu.c to rtl8xxxu_core.c
599119f683e6 rtl8xxxu: move rtl8192e related code into rtl8xxxu_8192e.c
6c46ca3b5f3b rtl8xxxu: move rtl8723b related code into rtl8xxxu_8723b.c
20e3b2e97edd rtl8xxxu: move rtl8723a related code into rtl8xxxu_8723a.c
181725dd4f33 rtl8xxxu: move rtl8188[cr] and rtl8192c related code into rtl8xxxu_8192c.c
97db5a87b0f0 rtl8xxxu: Rename rtl8723a_stop_tx_beacon() to rtl8xxxu_stop_tx_beacon()
a46b099ca730 rtl8xxxu: rename rtl8723a_channel_group() to rtl8xxxu_gen1_channel_to_group()
993dd9b425f5 rtl8xxxu: Rename rtl8723a_disabled_to_emu() to rtl8xxxu_disabled_to_emu()
9c0343d4f48b rtl8xxxu: Split rtl8723a_h2c_cmd() into a gen1 and a gen2 version
27c7e89ea77b rtl8xxxu: rtl8xxxu_prepare_calibrate() is never used on gen1
e1ca790c8a32 rtl8xxxu: Remove the now obsolete mbox_ext_reg info from rtl8xxxu_fileops

Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:55265 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2BHJ5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 04:57:42 -0500
Message-ID: <4F3244DF.8020909@adurom.com> (sfid-20120208_105745_816745_A39974E4)
Date: Wed, 08 Feb 2012 11:48:15 +0200
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix firmware crash dump
References: <1328684012-2209-1-git-send-email-ngangadh@qca.qualcomm.com>
In-Reply-To: <1328684012-2209-1-git-send-email-ngangadh@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 08:53 AM, Naveen Gangadharan wrote:
> Fixed a bug when we dump the firmware crash log.
> 
> Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>

Thanks, applied with these changes:

commit 3b96d49a79021ce4c1ca26aecd784d16aeb91a7c
Author: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
Date:   Tue Feb 7 22:53:32 2012 -0800

    ath6kl: Fix firmware crash dump

    The firmware crash dump printout was wrong as it was using incorrect
    offsets.

    kvalo: improve commit log, change the "%d:" to print word indexes,
not bytes

    Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle

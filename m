Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52217 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3JGM0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 08:26:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: advestise 10.X fw support on wmi_attach
References: <1380696532-4147-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 7 Oct 2013 15:26:36 +0300
In-Reply-To: <1380696532-4147-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 2 Oct 2013 08:48:51 +0200")
Message-ID: <8738oduv0j.fsf@kamboji.qca.qualcomm.com> (sfid-20131007_142645_917533_C60A1628)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Since the WMI API has been added and we can detect from the
> FW IEs what firmware variant we deal with, turn on 10.X support.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, both patches applied. For patch 1 I changed the commit log a bit
as we don't really advertise anything to user space:

commit 8acd3c97ff9ea803513c55f89d3f1832481b5b76
Author: Bartosz Markowski <bartosz.markowski@tieto.com>
Date:   Wed Oct 2 08:48:51 2013 +0200

    ath10k: enable 10.x firmware branch support
    
    Since the WMI API has been added and we can detect from the
    FW IEs what firmware variant we deal with, turn on support
    for 10.x firmware branch in ath10k_wmi_attach().
    
    kvalo: improve the commit log
    
    Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo

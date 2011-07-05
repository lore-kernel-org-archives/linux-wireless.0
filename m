Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:37237 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1GERtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 13:49:14 -0400
Received: by mail-bw0-f53.google.com with SMTP id 12so7607039bwg.40
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 10:49:13 -0700 (PDT)
Subject: Re: [PATCH 1/3] wl12xx: schedule TX packets according to FW
 occupancy
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308909817-25689-1-git-send-email-arik@wizery.com>
References: <1308909817-25689-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 20:49:09 +0300
Message-ID: <1309888149.1514.499.camel@cumari> (sfid-20110705_194928_262729_0323146A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-24 at 13:03 +0300, Arik Nemtsov wrote: 
> When selecting packets for transmission, prefer the ACs that are least
> occupied in the FW. When packets for multiple ACs are present in the FW,
> it decides which to transmit according to WMM QoS parameters.
> 
> With these changes, lower priority ACs should not be starved when higher
> priority traffic is present.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied the series, thanks!

-- 
Cheers,
Luca.


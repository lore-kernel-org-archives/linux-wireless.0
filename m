Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:51035 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab1GERns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 13:43:48 -0400
Received: by mail-bw0-f45.google.com with SMTP id 12so6401651bwd.32
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 10:43:44 -0700 (PDT)
Subject: Re: [PATCH 1/3] wl12xx: fix Tx security sequence number handling
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Oz Krakowski <ozk@ti.com>
In-Reply-To: <1308463496-15522-1-git-send-email-arik@wizery.com>
References: <1308463496-15522-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 20:43:41 +0300
Message-ID: <1309887821.1514.498.camel@cumari> (sfid-20110705_194408_100733_687A6278)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-06-19 at 09:04 +0300, Arik Nemtsov wrote: 
> From: Oz Krakowski <ozk@ti.com>
> 
> Do not reset the security sequence number when issuing a join command or
> interface is removed. Instead, reset the counter only during the unjoin
> command.
> 
> Added the notion of counter wrap-around to the LSB number in
> wl1271_tx_complete_packet.
> 
> Added post recovery padding to adjust for potential security number
> progress during the recovery process by the firmware and avoid
> potential interop issues in encrypted networks.
> 
> Signed-off-by: Oz Krakowski <ozk@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied the series, thanks!

Oz, nice to see a patch from you! :)

-- 
Cheers,
Luca.


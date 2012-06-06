Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:48184 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712Ab2FFRHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 13:07:31 -0400
Received: by lbbgg6 with SMTP id gg6so5905085lbb.36
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 10:07:12 -0700 (PDT)
Message-ID: <1339002430.7078.39.camel@cumari.coelho.fi> (sfid-20120606_190734_600082_5AB60B35)
Subject: Re: [PATCH v2] wlcore: do not send stop fwlog cmd if fw is hanged
From: Luciano Coelho <coelho@ti.com>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 20:07:10 +0300
In-Reply-To: <1337157258-15163-2-git-send-email-yoni.divinsky@ti.com>
References: <1337157258-15163-1-git-send-email-yoni.divinsky@ti.com>
	 <1337157258-15163-2-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 11:34 +0300, Yoni Divinsky wrote:
> If the driver received a watchdog interrupt then the
> assumption is that the fw is hanged. Avoid sending
> the stop fwlog command in case of a watchdog recovey
> to avoid waiting for the 2 seconds timeout of the command.
> 
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> ---

Thanks, Yoni! Applied.

--
Luca.


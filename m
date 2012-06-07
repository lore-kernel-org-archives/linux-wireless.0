Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:39596 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab2FGPgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 11:36:46 -0400
Received: by lbbgm6 with SMTP id gm6so632604lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 08:36:44 -0700 (PDT)
Message-ID: <1339083402.7078.101.camel@cumari.coelho.fi> (sfid-20120607_173649_502335_4A9590D8)
Subject: Re: [PATCH 0/5] wl18xx: add initial support for PG2.0 HW
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org, idor@ti.com, arik@wizery.com
Date: Thu, 07 Jun 2012 18:36:42 +0300
In-Reply-To: <1339060645-3574-1-git-send-email-coelho@ti.com>
References: <1339060645-3574-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:17 +0300, Luciano Coelho wrote:
> Hi,
> 
> Here are some patches to add support for PG2.0.  In the near future we
> will remove support for PG1.0 to keep the code simple and since nobody
> should be using that old R&D hardware version anymore, but for now we
> support both.

Applied and pushed this series to wl12xx.git/master.  Thanks Ido and
Arik!

--
Luca.


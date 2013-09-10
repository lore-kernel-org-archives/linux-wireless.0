Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:54892 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3IJGiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 02:38:50 -0400
Message-ID: <1378795155.4799.40.camel@porter.coelho.fi> (sfid-20130910_083853_111641_61A28274)
Subject: Re: [PATCH 05/12] wl18xx: increase the number of allowed BA sessions
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Sep 2013 09:39:15 +0300
In-Reply-To: <1378218848-7853-5-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-5-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> The current fw (actually starting from fw 8.5.0.0.58)
> supports 8 rx BA sessions.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

The latest firmware version published at linux-firmware.git is
8.5.0.0.55 (wl18xx-fw-2.bin), so this patch cannot be taken into the
official tree yet.

Please publish a newer version of the firmware (with appropriate
increase in the filename version), since I cannot do that myself
anymore.

--
Luca.


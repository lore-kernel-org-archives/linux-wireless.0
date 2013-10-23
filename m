Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:33749 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3JWHIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 03:08:11 -0400
Message-ID: <1382512029.21526.14.camel@porter.coelho.fi> (sfid-20131023_090814_839152_5E4AA322)
Subject: Re: [PATCH 01/13] wl18xx: default config alignment with phy defaults
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 23 Oct 2013 10:07:09 +0300
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-09 at 12:24 +0300, Eliad Peller wrote:
> From: Igal Chernobelsky <igalc@ti.com>
> 
> Driver default config is aligned with phy default parameters.
> 
> Now that RDL1_3 has 2 antennas defined by default we need to explicitly
> define ht.mode to HT_MODE_WIDE to have SISO40 as default.
> 
> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied the whole series except for 11/13 due to a sparse warning.

Sorry for the huge delay, at least I found the time to do it before the
merge window opened. ;)

--
Cheers,
Luca.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:52927 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269Ab2F0JHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 05:07:32 -0400
Received: by lbbgm6 with SMTP id gm6so1343902lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 02:07:28 -0700 (PDT)
Message-ID: <1340788046.1631.588.camel@cumari.coelho.fi> (sfid-20120627_110739_700327_CAC75DD6)
Subject: Re: [PATCH 0/5] wlcore/wl18xx: fixes and HW deprecation
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com
Date: Wed, 27 Jun 2012 12:07:26 +0300
In-Reply-To: <1340740980-22284-1-git-send-email-coelho@ti.com>
References: <1340740980-22284-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 23:02 +0300, Luciano Coelho wrote:
> Hi,
> 
> Here are a few more patches for wlcore and wl18xx.  Three patches by
> Eyal to fix a couple of bugs we found in the IO changes patchset and
> improve the recovery traces.
> 
> Also two patches of my own that deprecate an old HW version of the
> wl18xx chips (a sample PG1).  The reason to deprecate this is that
> these chips will never be used outside TI and removing support for it
> avoids some blunt caused by workarounds and other things that were
> fixed in the hardware (PG2).
> 
> Please review.

Applied and pushed the series.

--
Luca.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48614 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753111Ab1HILyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 07:54:12 -0400
Received: by mail-ey0-f172.google.com with SMTP id 4so4992761eye.17
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 04:54:10 -0700 (PDT)
Subject: Re: [PATCH 01/40] wl12xx: Revert "wl12xx: schedule TX packets
 according to FW occupancy"
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-2-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 14:54:07 +0300
Message-ID: <1312890847.2407.158.camel@cumari> (sfid-20110809_135415_912998_C62CC304)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> From: Arik Nemtsov <arik@wizery.com>
> 
> This does not make sense in 7.3 firmware - we don't use Tx blocks to
> measure FW occupancy anymore.

Should we be more precise about the firmware versions here? Maybe
mentioning >= 7.3.0.0.75 for wl128x and >= 6.3.0.0.75 for wl127x would
be good?

Should we also add a file, eg. called firmware.txt, in order to make it
easy for people to know which firmware they need to use for that
specific version? Of course we already have the fw-3 thingy, and we
should try to keep the kernel mainline always in sync with the
linux-firmware mainline, but maybe being more explicit would help users
of older kernels... It seems to be a recurring problem.

-- 
Cheers,
Luca.


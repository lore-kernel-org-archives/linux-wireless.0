Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab1LVPy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 10:54:27 -0500
Date: Thu, 22 Dec 2011 16:54:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christian Frost <cf@cfrost.dk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2800usb poor performance
Message-ID: <20111222155415.GA13554@redhat.com> (sfid-20111222_165436_531859_4009E782)
References: <CAA=oPaiE-NAP_rfi3BLv-wM_wBwfLyMh-p2KtMALXPaDG6LxxA@mail.gmail.com>
 <20111222141102.GA2261@redhat.com>
 <CAA=oPajYJQoz0AhAaGuY9y=2gbMUfpBZJU71TmryG_zksQk_Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA=oPajYJQoz0AhAaGuY9y=2gbMUfpBZJU71TmryG_zksQk_Nw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 22, 2011 at 03:42:00PM +0100, Christian Frost wrote:
> Yes, I have tried all your suggestions and they do not help. I
> havedownloaded the firmware from ralinktech in version v2.4.0.1

If you compile driver with CONFIG_RT2X00_DEBUG it will show exact
chip name. Please provide that info, we probably need to fix
that chip support in rt2800usb. For now you will need to use vendor
driver, which unfortunately will most likely work better than in kernel
driver for that particular chip.

Stanislaw

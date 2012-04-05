Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:46250 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755537Ab2DEGjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 02:39:12 -0400
Received: by bkwj5 with SMTP id j5so1238375bkw.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2012 23:39:09 -0700 (PDT)
Message-ID: <1333607947.27729.70.camel@cumari> (sfid-20120405_083916_783030_B2B7B5DA)
Subject: Re: wl1271 acx bet
From: Luciano Coelho <coelho@ti.com>
To: Yingang Fu <yingang.fu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 05 Apr 2012 09:39:07 +0300
In-Reply-To: <CAHPDcRuZyS_ibSBGgzDvREHcVCQOw=roia1RRrJUU3TtQOYGSA@mail.gmail.com>
References: <CAHPDcRuZyS_ibSBGgzDvREHcVCQOw=roia1RRrJUU3TtQOYGSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-05 at 11:41 +0800, Yingang Fu wrote: 
> hi, all

Hi Yingang,


> Does anybody could help me out of the meaning/function of the wl1271 acx bet?

BET means Beacon Early Termination.  What it does is to stop processing
a beacon when it realizes that there are not frames advertised by the AP
(and thus, the beacon is not useful to us).  This helps minimize power
consumption in PS mode.

-- 
Cheers,
Luca.


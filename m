Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:55760 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbdGYL6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 07:58:09 -0400
Date: Tue, 25 Jul 2017 04:58:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>
Subject: Re: [v3] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170725115805.GU10026@atomide.com> (sfid-20170725_135851_969576_0550E145)
References: <8665E2433BC68541A24DFFCA87B70F5B36409500@DFRE01.ent.ti.com>
 <20170725102211.GT10026@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B3640DDC7@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B3640DDC7@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170725 04:33]:
> > From: Tony Lindgren [mailto:tony@atomide.com]
> > Hmm so why would we ever even use this bogus nvs file? In addition to
> > warning,
> > I think we should just ignore the bogus nvs file completely.
> > 
> While it looks bogus, it is still at least a valid mac address and the chip will function
> Using it.
> Wilink6/7 doesn't have a  default mac address in hardware (wilink8 does have one)
> so we need to assign one for it so It can work, even if not optimally until configured 
> using the calibrator tool and a unique mac address is assigned to it.

But it's not a unique mac address. What we should do in that case is
use a random mac address just like many USB devices do.

Regards,

Tony

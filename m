Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:58887 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab1LWPEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 10:04:38 -0500
Received: by lahd3 with SMTP id d3so1663753lah.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 07:04:35 -0800 (PST)
Subject: Re: [PATCH 2/6] compat-wireless: remove platform_device_id for
 kernel < 2.6.30
From: Luciano Coelho <coelho@ti.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
In-Reply-To: <CAB=NE6X=yTDgLdGeR5ZzRW5qEmZkdyk2JC4LQ72RNYkq=iGMCw@mail.gmail.com>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
	 <1324586850-5212-3-git-send-email-hauke@hauke-m.de>
	 <1324630694.2182.325.camel@cumari>
	 <CAB=NE6X=yTDgLdGeR5ZzRW5qEmZkdyk2JC4LQ72RNYkq=iGMCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 17:04:32 +0200
Message-ID: <1324652672.2182.354.camel@cumari> (sfid-20111223_160441_874109_76E3CBC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-23 at 07:00 -0800, Luis R. Rodriguez wrote: 
> On Fri, Dec 23, 2011 at 12:58 AM, Luciano Coelho <coelho@ti.com> wrote:
> > The question is, should we even bother compiling wl12xx if the kernel is
> > < .30?
> 
> You would know better, what systems would even have the driver, etc. I
> welcome such patch. For now I'll apply this series.

Right, please go ahead and apply it.  My comment was not meant to be a
NACK. :)

-- 
Cheers,
Luca.


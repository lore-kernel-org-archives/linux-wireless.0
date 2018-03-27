Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:9685 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751995AbeC0Mhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 08:37:36 -0400
Message-ID: <1522154254.3786.269.camel@intel.com> (sfid-20180327_143741_623506_CD2E7ABE)
Subject: Re: [PATCH] iwlwifi: add device ID for Rivet Networks Killer
 Wireless-AC 1550
From: Luciano Coelho <luciano.coelho@intel.com>
To: Izzy Kulbe <kernel@unikorn.me>, Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 15:37:34 +0300
In-Reply-To: <2c826451177bbcb8fe033631dc7b87eb92f5e42d.camel@unikorn.me>
References: <1522148065.12122.5.camel@unikorn.me>
         <87370lrb7y.fsf@kamboji.qca.qualcomm.com>
         <2c826451177bbcb8fe033631dc7b87eb92f5e42d.camel@unikorn.me>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 14:03 +0200, Izzy Kulbe wrote:
> On Tue, 2018-03-27 at 14:48 +0300, Kalle Valo wrote:
> > Izzy Kulbe <kernel@unikorn.me> writes:
> > 
> > > nvm the last message, attached the wrong file using the 9270
> > > instead of the 9260 firmware, which obviously wouldn't work.
> > > Here's the working patch:
> > > 
> > > 
> > > Add support for Rivet Networks Killer Wireless-AC 1550 chipset, 
> > > which is using the Intel Wireless-AC 9260 chip
> > > 
> > > Signed-off-by: Izzy Kulbe <kernel@unikorn.me>
> > > 
> > > ---
> > 
> > You should put the comment "nvm the last message..." under the "---
> > "
> > line so that git-am can ignore it.
> 
> Sorry, still new to the whole process. should i just resend 
> that message with the proper order? 

Wait a bit.  This ID looks strange, someone else reported this already
and it looked strange, with an incorrect subsystem vendor ID.

Can you run lspci like this and let us know the results?

lspci -nv -s 3b:00.0

--
Cheers,
Luca.

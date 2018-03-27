Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.unikorn.me ([176.9.143.13]:42224 "EHLO mail.unikorn.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbeC0MDi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 08:03:38 -0400
Message-ID: <2c826451177bbcb8fe033631dc7b87eb92f5e42d.camel@unikorn.me> (sfid-20180327_140342_964180_66D2575B)
Subject: Re: [PATCH] iwlwifi: add device ID for Rivet Networks Killer
 Wireless-AC 1550
From: Izzy Kulbe <kernel@unikorn.me>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: luciano.coelho@intel.com, linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 14:03:31 +0200
In-Reply-To: <87370lrb7y.fsf@kamboji.qca.qualcomm.com>
References: <1522148065.12122.5.camel@unikorn.me>
         <87370lrb7y.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 14:48 +0300, Kalle Valo wrote:
> Izzy Kulbe <kernel@unikorn.me> writes:
> 
> > nvm the last message, attached the wrong file using the 9270 instead of the 9260 firmware, which obviously wouldn't work. Here's the working patch:
> > 
> > 
> > Add support for Rivet Networks Killer Wireless-AC 1550 chipset, 
> > which is using the Intel Wireless-AC 9260 chip
> > 
> > Signed-off-by: Izzy Kulbe <kernel@unikorn.me>
> > 
> > ---
> 
> You should put the comment "nvm the last message..." under the "---"
> line so that git-am can ignore it.

Sorry, still new to the whole process. should i just resend 
that message with the proper order? 

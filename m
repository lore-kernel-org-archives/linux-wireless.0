Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42674 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757364AbcK3Nye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 08:54:34 -0500
Message-ID: <1480514067.29540.54.camel@coelho.fi> (sfid-20161130_145459_411120_990043AF)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>, Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, briselec@gmail.com
Date: Wed, 30 Nov 2016 15:54:27 +0200
In-Reply-To: <87mvghtkwd.fsf@kamboji.qca.qualcomm.com>
References: <20161129235902.11882-1-Jes.Sorensen@redhat.com>
         <87mvghtkwd.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/1] rtl8xxxu: Workaround for 8192eu/8723bu not
 reconnecting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-11-30 at 10:46 +0200, Kalle Valo wrote:
> Jes.Sorensen@redhat.com writes:
> 
> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> > 
> > Hi,
> > 
> > This patch works around the issue with 8192eu and 8723bu devices not
> > being able to reconnect. It is still not clear why this fails, and
> > looking at rtlwifi it does issue the command for 8192ee and 8723be
> > devices.
> > 
> > Until we have a better idea of what is going on, I have commented out
> > the offending code. I prefer not deleting it until we have a better
> > understanding of why this is causing issues.
> > 
> > Credits to Barry Day for tracking down and isolating the issue.
> > 
> > Kalle, not sure if this can make it to 4.9, but if it's possible it
> > would be ideal since this is causing real issues in the field.
> 
> For 4.9 this is too late, sorry. I'll queue this to 4.10.

You should then CC stable so it gets into 4.9.x when it reaches 4.10.

--
Luca.

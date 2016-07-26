Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36155 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcGZNNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 09:13:52 -0400
Received: by mail-wm0-f49.google.com with SMTP id q128so172918912wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2016 06:13:52 -0700 (PDT)
Date: Tue, 26 Jul 2016 14:13:47 +0100
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 wl-drv-next 0/2] register-field manipulation macros
Message-ID: <20160726141347.19ecd203@jkicinski-Precision-T1700> (sfid-20160726_151421_502508_2F4D7F8C)
In-Reply-To: <87y44od06j.fsf@kamboji.qca.qualcomm.com>
References: <1467821977-11777-1-git-send-email-jakub.kicinski@netronome.com>
	<20160725154549.6492cac1@jkicinski-Precision-T1700>
	<87y44od06j.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Jul 2016 16:00:04 +0300, Kalle Valo wrote:
> Jakub Kicinski <jakub.kicinski@netronome.com> writes:
> 
> > On Wed,  6 Jul 2016 17:19:35 +0100, Jakub Kicinski wrote:  
> >> Hi!
> >> 
> >> I've added few lines about the compilation problems in 
> >> the commit message of patch 1.  I would prefer the mass
> >> rename of macros in mt7601u not to be part of this series
> >> so patch 2 is left as it was and I'll follow up once this
> >> is accepted.  
> >
> > Hi Kalle,
> >
> > what's the status of this set?  It's marked as 'Deferred' in
> > linux-wireless patchwork.  
> 
> Like I said before, I would prefer to see an ack from someone else like
> Andrew Morton or Dave Miller. I don't feel comfortable adding new files
> to include/ without some sort of support from others. Or maybe Andrew
> could even take these directly to his tree?

OK, once the merge window is over I'll repost and TO: some important
guys.  Hopefully we'll catch someone's attention :)

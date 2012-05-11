Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60175 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731Ab2EKF5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 01:57:30 -0400
Received: by lahm15 with SMTP id m15so2118849lah.37
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 22:57:27 -0700 (PDT)
Message-ID: <1336715845.12189.160.camel@cumari.coelho.fi> (sfid-20120511_075734_393229_3E0FE491)
Subject: Re: [PATCH 00/78] 18xx chip support
From: Luciano Coelho <coelho@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	assaf@ti.com
Date: Fri, 11 May 2012 08:57:25 +0300
In-Reply-To: <87ipg48ivh.fsf@purkki.adurom.net>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
	 <87ipg48ivh.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Thu, 2012-05-10 at 12:50 +0300, Kalle Valo wrote:
> Arik Nemtsov <arik@wizery.com> writes:
> 
> > This series adds initial support for the 18xx chip family. The new
> > module uses wlcore for functionality common with the 12xx family.
> 
> You do know that sending 78 patches in one patchset is very much
> frowned upon? No sane person (outside of wl12xx) is going to review
> all of these.

Yes, I totally agree with you.  I have been trying to send all this
stuff in smaller batches that would be much easier to review and manage
upstream.  We wanted to squash many of them, clean things up a bit more
and so on, but we diverged so much from the mainline (we had close to
100 patches dragging in our internal trees) that all the rebases and
even small squashes or moving patches around became a horrible
nightmare.

As you know, I've been on sick leave for a while, so all this work would
have dragged even longer if Arik and the rest of the team didn't take an
action to get it out.

To conclude, even though I don't like the way this was done, now it's
done and sending this series again in smaller batches would just make
things worse, because not only there would still be a huge bunch of
patches in total, most of them would actually be duplicate or just
slightly modified.  

So, unless you or someone else really disagrees, I'll apply these to the
wl12xx.git tree.

And then I'll go find Arik to remove some of his fingernails, especially
the one on his right hand pinky so he can't hit ENTER so quickly after
typing git send-email. :P

-- 
Cheers,
Luca.


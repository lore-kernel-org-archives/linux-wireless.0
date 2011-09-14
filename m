Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51399 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756057Ab1INJ4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:56:07 -0400
Received: by mail-bw0-f48.google.com with SMTP id zu5so2274664bkb.21
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:56:06 -0700 (PDT)
Subject: Re: [PATCH 2/6] wl12xx: AP mode - don't regulate FW blocks for
 non-active STAs
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org
In-Reply-To: <CA+XVXff93Qhj6URUMzE99j30NVB+4_M_NwsxHKYOxbHwpwE1yg@mail.gmail.com>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
	 <1314265397-19873-2-git-send-email-arik@wizery.com>
	 <871uw9olg7.fsf@purkki.adurom.net>
	 <CA+XVXff93Qhj6URUMzE99j30NVB+4_M_NwsxHKYOxbHwpwE1yg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 12:56:02 +0300
Message-ID: <1315994162.2498.88.camel@cumari> (sfid-20110914_115611_463954_8F09855E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-14 at 12:44 +0300, Arik Nemtsov wrote: 
> On Thu, Aug 25, 2011 at 13:05, Kalle Valo <kvalo@adurom.com> wrote:
> > Arik Nemtsov <arik@wizery.com> writes:
> >
> >> +     if (!wl1271_is_active_sta(wl, hlid)) {
> >> +             WARN_ON(1);
> >> +             return;
> >> +     }
> >
> > I think this is neater:
> >
> > if (WARN_ON(!wl1271_is_active_sta(wl, hlid))
> >        return;
> 
> (Sorry for the late response)
> 
> It does look nicer. Luca - do you mind changing it before merging?

Done, and thanks for giving me more work to do! Oh, well, I deserved
it. :P

-- 
Cheers,
Luca.


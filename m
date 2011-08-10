Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:52129 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab1HJK1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 06:27:45 -0400
Received: by mail-fx0-f41.google.com with SMTP id 9so1110020fxg.14
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 03:27:44 -0700 (PDT)
Subject: Re: [PATCH 08/40] wl12xx: wl12xx-fw-3 - update commands & events
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEf-TyTfuF_p6WcZVn2T7_3A+K75GeYLAOOzHcx12qX7mA@mail.gmail.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-9-git-send-email-eliad@wizery.com>
	 <1312967955.2407.452.camel@cumari>
	 <CAB3XZEf-TyTfuF_p6WcZVn2T7_3A+K75GeYLAOOzHcx12qX7mA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 13:27:41 +0300
Message-ID: <1312972061.2407.474.camel@cumari> (sfid-20110810_122748_636098_FA60FF55)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 13:24 +0300, Eliad Peller wrote: 
> On Wed, Aug 10, 2011 at 12:19 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
> >> +enum wl1271_cmd_lid_key_type {
> >> +     UNICAST_LID_TYPE     = 0,
> >> +     BROADCAST_LID_TYPE   = 1,
> >> +     WEP_DEFAULT_LID_TYPE = 2
> >> +};
> >
> > Doesn't LID_TYPE_UNICAST, LID_TYPE_BROADCAST and so on look better?
> >
> it does, but i didn't touch this struct (it wasn't in the context diff
> expected, so it looks like it was deleted and re-added), and i should
> avoid adding more stuff (changing all the existing uses of this enum)
> to this already-too-big patch.

Right, right.  I didn't realize that this was actually moved, not added
here.

-- 
Cheers,
Luca.


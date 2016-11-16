Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47622 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751955AbcKPNIE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 08:08:04 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC: Xinming Hu <huxm@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        "Nishant Sarmukadam" <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH v2 1/5] mwifiex: remove redundant condition in main
 process
Date: Wed, 16 Nov 2016 13:08:00 +0000
Message-ID: <b323f9644b9a42a5a0a8aee20bcf86e7@SC-EXCH04.marvell.com> (sfid-20161116_140807_540727_806E24CD)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <20161027183536.GA28717@localhost>
 <eda7a256a6574baeb8e1a12c15c2e6b0@SC-EXCH02.marvell.com>
 <878tsvruum.fsf@purkki.adurom.net> <20161110194646.GA85922@google.com>
In-Reply-To: <20161110194646.GA85922@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Friday, November 11, 2016 1:17 AM
> To: Kalle Valo
> Cc: Xinming Hu; Amitkumar Karwar; linux-wireless@vger.kernel.org; Cathy
> Luo; Nishant Sarmukadam; rajatja@google.com; dmitry.torokhov@gmail.com
> Subject: Re: [PATCH v2 1/5] mwifiex: remove redundant condition in main
> process
> 
> On Mon, Nov 07, 2016 at 08:46:41PM +0200, Kalle Valo wrote:
> > Xinming Hu <huxm@marvell.com> writes:
> >
> > > We have include below change in latest submit
> > > https://patchwork.kernel.org/patch/9407283/
> > > Please drop this patch.
> >
> > When making changes please resend the whole patchset. I do not want
> to
> > individually pick patches from different places, that will eventually
> > go wrong anyway. So I just apply full patchsets.
> 
> I'm going to assume that Xinming intended that the entire series be
> resent, possibly without this patch. There were enough other issues in
> the series anyway.

I will submit v3 series shortly.

Regards,
Amitkumar

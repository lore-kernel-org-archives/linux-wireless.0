Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48359 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab1F3UQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 16:16:24 -0400
Received: by mail-bw0-f45.google.com with SMTP id 12so3427386bwd.18
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 13:16:23 -0700 (PDT)
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and bug
 fixed
From: Luciano Coelho <coelho@ti.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>
In-Reply-To: <4E0CB587.3000209@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
	 <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com>
	 <4E0CB587.3000209@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 23:16:19 +0300
Message-ID: <1309464979.1514.177.camel@cumari> (sfid-20110630_221627_640018_3F0E9330)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henry,

On Thu, 2011-06-30 at 10:42 -0700, Henry Ptasinski wrote: 
> On 06/29/2011 11:29 PM, Rafał Miłecki wrote:
> > 2011/6/30 Franky Lin<frankyl@broadcom.com>:
> >> Most of these patches are brcmfmac cleanup.
> >
> >
> > Hm, interesting improvement in your "Release early, release often" strategy.
> >
> 
> Yea, we were waiting for the previous series to get applied.  Not sure 
> how to make this work better.  Any process suggestions would be appreciated.

Keep sending them in small batches, I think it is just normal to apply
the batches one after the other, no need to keep waiting.  If there are
no conflicts, everything should go smoothly.  And if it doesn't, someone
will ping you. ;)


-- 
Cheers,
Luca.


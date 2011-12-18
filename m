Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:60451 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab1LRHmo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 02:42:44 -0500
Received: by mail-iy0-f175.google.com with SMTP id h37so3281975iak.6
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 23:42:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323871164.8146.0.camel@jlt3.sipsolutions.net>
References: <1323870210.97711.YahooMailNeo@web28203.mail.ukl.yahoo.com>
	<1323871164.8146.0.camel@jlt3.sipsolutions.net>
Date: Sun, 18 Dec 2011 09:42:43 +0200
Message-ID: <CANJm+iAm2pzESyLv8fmCkQYa6cD2HyxhAWN+eCGar_Q4gvd4xw@mail.gmail.com> (sfid-20111218_084247_991940_1F8688B5)
Subject: Re: wmm admission control in mac80211
From: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
To: Soumik Das <soumik_kgp@yahoo.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 3:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Wed, 2011-12-14 at 13:43 +0000, Soumik Das wrote:
> > Hi,
> >
> > I was looking at the mac80211. It seems there is no support for admission control in the current implementation.
> >
> >
> > Is there any near term plan for adding the support? Otherwise can I add the support myself?
>
> I don't know of any plans to add it, but feel free to.
>

I have started and implementation to support wmm admission control in mac80211

The implementation also included an API with nl80211.

I will probably send an RFC in the upcoming days.

Thanks,
Yoni Divinsky

> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

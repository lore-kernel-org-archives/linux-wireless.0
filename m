Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ukl.yahoo.com ([217.146.182.248]:36252 "HELO
	nm7.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750911Ab2COGWw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 02:22:52 -0400
References: <1323870210.97711.YahooMailNeo@web28203.mail.ukl.yahoo.com> <1323871164.8146.0.camel@jlt3.sipsolutions.net> <CANJm+iAm2pzESyLv8fmCkQYa6cD2HyxhAWN+eCGar_Q4gvd4xw@mail.gmail.com>
Message-ID: <1331792570.68534.YahooMailNeo@web28210.mail.ukl.yahoo.com> (sfid-20120315_072256_846200_289EF5A6)
Date: Thu, 15 Mar 2012 06:22:50 +0000 (GMT)
From: Soumik Das <soumik_kgp@yahoo.co.uk>
Reply-To: Soumik Das <soumik_kgp@yahoo.co.uk>
Subject: Re: wmm admission control in mac80211
To: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CANJm+iAm2pzESyLv8fmCkQYa6cD2HyxhAWN+eCGar_Q4gvd4xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In the current driver operation (ieee80211_ops)  there is no provision for configuring medium time. But this would be essential for admission control.

Will it be better to add a new (optional) operation in ieee80211 or can we add a new field in ieee80211_tx_queue_params?

Regards,
Soumik



----- Original Message -----
From: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
To: Soumik Das <soumik_kgp@yahoo.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>; "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Sent: Sunday, 18 December 2011, 13:12
Subject: Re: wmm admission control in mac80211

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
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


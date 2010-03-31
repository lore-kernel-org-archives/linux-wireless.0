Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:29362 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0CaE5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 00:57:50 -0400
Subject: Re: [PATCH] iw: Add support for connection quality monitor
 configuation
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1269584501.4581.5.camel@jlt3.sipsolutions.net>
References: <1269582379-10253-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269583649.4581.4.camel@jlt3.sipsolutions.net>
	 <1269584079.10120.889.camel@wimaxnb.nmp.nokia.com>
	 <1269584501.4581.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 07:53:28 +0300
Message-ID: <1270011208.10120.906.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2010-03-26 at 07:21 +0100, ext Johannes Berg wrote:
> > > > +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_THOLD, thold);
> > > > +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_HYST, hyst);
> > > 
> > > Hmm. guess I missed that in the kernel side review, but should we change
> > > the API so that leaving them out means disabling?
> > 
> > Heh, yep, the kernel part does not disable this if these are left out. 
> > 
> > Actually, I can think of one downside to the approach you propose: when
> > this gets extended, there will be multiple different cqm parameters, and
> > they would have to be always configured simultaneously, otherwise some
> > of the configurations would end up disabled. At least with iw, that
> > would be somewhat awkward?
> 
> Hmm, yes, maybe. In that case you'd want leaving them out meaning no
> change I guess. I'll give it another thought, but now I need to get
> sleep and you won't hear from me again until I'm home on like Sunday :)

Have you reached any conclusions on this matter? To get this support
into iw would help my work greatly ;)

-Juuso

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



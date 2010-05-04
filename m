Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24068 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0EDFXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 01:23:46 -0400
Subject: Re: [RFC PATCHv4 0/2] mac80211: cfg80211: dynamic ps timeout based
 on 	pm-qos
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <o2z43e72e891005031544ufd3f84a5g4e0a3a0dceac8002@mail.gmail.com>
References: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
	 <87633al6di.fsf@purkki.valot.fi>
	 <o2z43e72e891005031544ufd3f84a5g4e0a3a0dceac8002@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 08:25:13 +0300
Message-ID: <1272950713.6205.10584.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 00:44 +0200, ext Luis R. Rodriguez wrote:
> On Thu, Apr 29, 2010 at 6:45 AM, Kalle Valo <kvalo@adurom.com> wrote:
> > Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> >
> >> These patches propose a way to adjust the dynamic ps timeout in the
> >> mac80211 based on the pm-qos network latency value. This allows user
> >> space to influence the level of power saving performed by the
> >> mac80211.
> >>
> >> v4 of these patches change the way pm qos network latency ranges
> >> converted to dynamic ps timeout values a little bit saner. Unlike
> >> the previous set of patches, now the latancy values make sense in a
> >> wider scope than this ps timeout thing only. I hope this makes them
> >> somewhat more future-proof.
> >
> > This looks very good now. Bonus points for adding the comment about
> > the two second value!
> >
> > Thank you for implementing this.
> 
> Even more bonus points (if this was a video game you'd get an extra
> life) if you add the new changes on the documentation here:
> 
> http://wireless.kernel.org/en/developers/Documentation/pm-qos
> 

Can't resist a new life! Yes, I will add the changes. Honestly, I was
planning to, and almost remembered ;)

-Juuso

>   Luis



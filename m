Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:4464 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXGDGNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 02:13:22 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1997595wxd
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2007 23:13:21 -0700 (PDT)
Message-ID: <1ba2fa240707032313p7209117bycc8ee7335447afea@mail.gmail.com>
Date: Wed, 4 Jul 2007 09:13:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Benc" <jbenc@suse.cz>
Subject: Re: [WIP] mac80211: kill mgmt interface
Cc: "Joerg Pommnitz" <pommnitz@yahoo.com>,
	"Cohen, Guy" <guy.cohen@intel.com>, linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20070702155309.5300ef7f@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <394827.41199.qm@web51403.mail.re2.yahoo.com>
	 <20070702155309.5300ef7f@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/2/07, Jiri Benc <jbenc@suse.cz> wrote:
> > Von: "Cohen, Guy" <guy.cohen@intel.com>
> > > This is a required feature for Access Points (multiple BSSID).
>
> On Mon, 2 Jul 2007 06:38:00 -0700 (PDT), Joerg Pommnitz wrote:
> > And, just from reading the documentation, it seems to be supported by MadWifi for Atheros
> > based devices:
> >
> > http://madwifi.org/wiki/ngFeatures
> >
> > and note the "To create APs which share a single MAC address, use the -bssid flag when
> > creating the VAPs:"  remark.
> >
> > Even if no current mac80211 driver supports this feature, the API must not prevent this in the future.
>
> What are you talking about? Have you actually looked at mac80211? This
> is supported from day 0 of d80211.
>
>  Jiri
>
There is probably difference between running multiple hostapd
instances and running in multiple BSSID mode over one interface,
meaning that hostapad is running multiple instances of MLME. I guess
the original post was a bit confusing.
I'm not sure if and how current implementation of hostapd can do that,
but that's probably question for another mailing list.

> --
> Jiri Benc
> SUSE Labs
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

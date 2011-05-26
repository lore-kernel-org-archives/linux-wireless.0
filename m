Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634Ab1EZRYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 13:24:36 -0400
Subject: Re: [iwl4965] Microcode SW error detected
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-wireless@vger.kernel.org
Date: Thu, 26 May 2011 12:26:48 -0500
In-Reply-To: <20110525131130.GA3260@redhat.com>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <20110524070941.GA2189@redhat.com>
	 <1306255853.12267.14.camel@x61.thuisdomein>
	 <20110525131130.GA3260@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1306430810.3151.4.camel@dcbw.foobar.com> (sfid-20110526_192439_537174_3A223EE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-25 at 15:11 +0200, Stanislaw Gruszka wrote:
> On Tue, May 24, 2011 at 06:50:53PM +0200, Paul Bolle wrote:
> > On Tue, 2011-05-24 at 09:09 +0200, Stanislaw Gruszka wrote:
> > > What is your configuration (mode,
> > > encryption, do you use wpa_supplicant or NetworkManager, which version,
> > > etc ...)?
> > 
> > 0) Mode as is displayed in iwconfig output? That is "Managed".
> > 
> > 1) Encryption is wep (so, no wpa_supplicant).
> > 
> > 2) Currently using NetworkManager-0.8.4-1.fc14.x86_64.
> 
> I try to use WEP with one AP, no microcode errors. However with different
> NetworkManager version, not sure if it is important. I'll try lately on F-14. 
> What channel do you use? Is network 11n or 11g or mixed ? WEP is 40 bits or
> other?

If it makes a difference, NM 0.8.x uses only the 'wext' supplicant
driver and uses wpa_supplicant 0.6.x.  NM still requests periodic scans
about every 2 minutes as usual.

(F15+, ie NM 0.9, uses "nl80211,wext" and supplicant 0.7.3+git)

Dan

> > > I will try to reproduce locally. If I'll be not able to reproduce,
> > > I'll ask you for debug logs on broken, and working (i.e. 2.6.38) version
> > > for compare.
> > 
> > 3) Sure, no problem. But isn't 2.6.38 from before the iwlegacy split?
> Yes, it is. If the problem was introduced during driver split (that
> happen in 2.6.39), one way to find a fix would be compare driver
> behaviour before the split and after.
> 
> Stanislaw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



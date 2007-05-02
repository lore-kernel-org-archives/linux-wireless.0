Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.236]:50094 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993338AbXEBPSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 11:18:00 -0400
Received: by nz-out-0506.google.com with SMTP id o1so165719nzf
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2007 08:18:00 -0700 (PDT)
Message-ID: <f6ca9fed0705020817j2c6e70e1x3b4046fe31e30c1a@mail.gmail.com>
Date: Wed, 2 May 2007 17:17:59 +0200
From: "dragoran dragoran" <drago01@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: mac80211 and signal strength reporting
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4638A68C.3000600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <46384D34.9080505@gmail.com> <4638A68C.3000600@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/2/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> dragoran wrote:
> > Hello,
> > while testing iwlwifi (which works fine now btw) I noticed that the
> > signal strenght reporting when using mac80211 is broken:
> > iwconfig only show dBm value....
> > gnome-netstatus always shows 0%
> > networkmanager always shows 100%
> > whats going on? does some has any idea?
> > is this a known bug or is iwlwifi the culprit?
>
> A little of both. The wireless statistics code in mac80211 has some strange
> conventions. I worked
> for a while on improving it, but there are multiple opinions regarding the
> use of terms such as
> "level" and "signal". After a few tries, I dropped that part and made
> bcm43xx-mac80211 conform to
> the mac80211 conventions. Now there are lines like "Link Quality=77/100
> Signal level=-49 dBm  Noise
> level=-73 dBm" in the iwconfig output. These values look reasonable.
>

ok I don't see any of them when using iwlwifi ..so its a iwlwifi bug?

(resend)

> Larry
>

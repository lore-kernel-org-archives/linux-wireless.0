Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55308.mail.re4.yahoo.com ([206.190.58.187]:44490 "HELO
	web55308.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751669AbZHEQPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 12:15:33 -0400
Message-ID: <175701.5780.qm@web55308.mail.re4.yahoo.com>
Date: Wed, 5 Aug 2009 09:08:54 -0700 (PDT)
From: xxiao <austinxxh-ath9k@yahoo.com>
Reply-To: austinxxh-ath9k@yahoo.com
Subject: Re: Status of 802.11s in wireless-testing?
To: devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2f1373ed0908042145pc83adc5qd968e3bf8d0ce3c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I didn't see patches from open80211s project for a while, which means it will break as the rest mac80211/drivers are evolving quickly.

to get mesh working I now spend more time to use the ibss/ad-hoc mode in mac80211 instead.

xxiao

--- On Tue, 8/4/09, Steve Glass <stevie.glass@gmail.com> wrote:

> From: Steve Glass <stevie.glass@gmail.com>
> Subject: Status of 802.11s in wireless-testing?
> To: devel@lists.open80211s.org
> Date: Tuesday, August 4, 2009, 11:45 PM
> Hi,
> 
> I noticed today that 802.11s has been disabled when running
> "make xconfig". Apparently its been marked as
> broken although Luis Rodriguez has posted a patch to at
> least have it compile successfully.
> 
> 
> I missed all this because I usually run "make
> oldconfig" so it came as a surprise . It did, however,
> explain why iw was telling me that my ath5k device supported
> mesh point mode but would fail when I tried to create one.
> 
> 
>  What can we do to help? Its a huge step backwards to be
> marked as broken so I've applied Luis' compilation
> patch and want to know where to look to find out what
> functionality is broken. Is anyone working on it? What can
> we do to help?
> 
> 
> Stevie
> 
> -- 
> The highest human happiness is not the exploitation of the
> present but the preparation of the future.
> 
> 
> -----Inline Attachment Follows-----
> 
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://open80211s.com/mailman/listinfo/devel
> 

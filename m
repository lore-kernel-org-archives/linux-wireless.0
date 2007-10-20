Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58254 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbXJTFkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 01:40:42 -0400
Message-ID: <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net> (sfid-20071020_064047_193599_A33AFE25)
Date: Sat, 20 Oct 2007 01:40:40 -0400
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 lists supported rates backwards
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
In-Reply-To: <47192F84.1020101@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Larry Finger <larry.finger@lwfinger.net>:

> Using the latest git pull from Linus, I am able to associate with my  
>  BEFW11S4 AP using the b43
> driver. The problem is probably not in mac80211.

Sorry, I should have mentioned that.  I tested bcm43xx-mac80211 from  
the latest Fedora 7 kernel and it was fine with that router.  ath5k  
from wireless-2.6/everything was also fine.  Current MadWifi is fine.   
Current at76_usb (not mac80211 based yet) is fine.  It's only the  
Intel 3945 card that has problems with it.

I don't know why iwl3945 composes the association request on its own  
and what happens to it later.  Besides, mac80211 10.0.0 is something  
heavily patched by Intel AFAIK.  I wanted to test the git version of  
Intel mac80211, but intellinuxwireless.org appears to be down or  
unreachable at the moment and I didn't have a recent clone.  The  
kernel mac80211 is definitely not the suspect.

I was aware of "error 18", and when I noticed some activity about  
rates in wireless-2.6/everything, so I decided to see how that problem  
would be affected.

-- 
Regards,
Pavel Roskin

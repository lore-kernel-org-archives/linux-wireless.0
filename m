Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:47162 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXJTIVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 04:21:49 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1163161mue
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2007 01:21:47 -0700 (PDT)
Message-ID: <4719BA96.3010609@gmail.com> (sfid-20071020_092157_375768_5F4EEE2E)
Date: Sat, 20 Oct 2007 10:21:42 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 lists supported rates backwards
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net> <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
In-Reply-To: <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Quoting Larry Finger <larry.finger@lwfinger.net>:
>
>> Using the latest git pull from Linus, I am able to associate with my 
>>  BEFW11S4 AP using the b43
>> driver. The problem is probably not in mac80211.
>
> Sorry, I should have mentioned that.  I tested bcm43xx-mac80211 from 
> the latest Fedora 7 kernel and it was fine with that router.  ath5k 
> from wireless-2.6/everything was also fine.  Current MadWifi is fine.  
> Current at76_usb (not mac80211 based yet) is fine.  It's only the 
> Intel 3945 card that has problems with it.
>
> I don't know why iwl3945 composes the association request on its own 
> and what happens to it later.  Besides, mac80211 10.0.0 is something 
> heavily patched by Intel AFAIK.  I wanted to test the git version of 
> Intel mac80211, but intellinuxwireless.org appears to be down or 
> unreachable at the moment and I didn't have a recent clone.  The 
> kernel mac80211 is definitely not the suspect.
>
> I was aware of "error 18", and when I noticed some activity about 
> rates in wireless-2.6/everything, so I decided to see how that problem 
> would be affected.
>
does loading the module with disable_hw_scan=1 helps?

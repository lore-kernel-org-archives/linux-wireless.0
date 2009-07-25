Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:36464 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbZGYFzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 01:55:54 -0400
Received: by fg-out-1718.google.com with SMTP id e12so212451fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 22:55:52 -0700 (PDT)
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: wireless-testing regression: iwl3945 scan fails
References: <87k521s2wa.fsf@litku.valot.fi> <87fxcosron.fsf@litku.valot.fi>
	<1248278121.17896.2728.camel@rc-desk> <874ot2sa51.fsf@litku.valot.fi>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 25 Jul 2009 08:55:47 +0300
In-Reply-To: <874ot2sa51.fsf@litku.valot.fi> (Kalle Valo's message of "Fri\, 24 Jul 2009 12\:28\:10 +0300")
Message-ID: <87skglqpb0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> reinette chatre <reinette.chatre@intel.com> writes:
>
>> Are you saying that this problem occurs always with wpa_supplicant and
>> sometimes with iw?
>
> I did some more testing and I can now reproduce this with iw as well. I
> just need to reboot my laptop to reproduce it. I'll debug this more on a
> rainy day.

This is getting very odd, I cannot reproduce the problem anymore with
rc4-wl. Just to be safe, I rebooted back to rc3-wl and I was immediately
able to reproduce it. To summarise, rc2-wl and rc4-wl were ok and only
rc3-wl is broken. So something fixed this, I just don't know what.

-- 
Kalle Valo

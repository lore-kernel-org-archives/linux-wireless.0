Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:46965 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643AbZDLMuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 08:50:04 -0400
Received: by fg-out-1718.google.com with SMTP id e12so539020fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 12 Apr 2009 05:50:02 -0700 (PDT)
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1239519983.4652.0.camel@johannes.local>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)  <1239136637.7475.57.camel@johannes.local>
	 <1239395434.13792.3.camel@maxim-laptop>
	 (sfid-20090410_223110_294055_69850902)  <1239449651.17031.42.camel@johannes.local>
	 <1239494152.8136.8.camel@maxim-laptop>
	 (sfid-20090412_015626_668863_2CED8163)  <1239519983.4652.0.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 15:49:59 +0300
Message-Id: <1239540599.11641.0.camel@maxim-laptop> (sfid-20090412_145009_982688_5AB78366)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-04-12 at 09:06 +0200, Johannes Berg wrote:
> On Sun, 2009-04-12 at 02:55 +0300, Maxim Levitsky wrote:
> 
> > > > > [ 1666.298395] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wireless/core.h:79 nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()
> 
> > You mean "[PATCH] cfg80211: convert mutex assert to macro"
> > 
> > With the patch:
> 
> I really want the line as above now :)

Hi,

I have just compiled 2.6.30-rc1 (latest -git of linus kernel tree), and
this warning is gone).

Best regards,
	Maxim Levitsky


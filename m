Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56074 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZKMIze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 03:55:34 -0500
Received: by bwz27 with SMTP id 27so3156106bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 00:55:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258097485.3899.76.camel@johannes.local>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	 <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	 <20091112154440.GD19349@tux>
	 <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	 <40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	 <1258054304.3899.36.camel@johannes.local>
	 <40101cc30911121418h4109d62bv763bed2036446901@mail.gmail.com>
	 <1258097485.3899.76.camel@johannes.local>
Date: Fri, 13 Nov 2009 09:55:37 +0100
Message-ID: <f74418680911130055o7d8fa94brc3fd7a0c315bb7b0@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: rodriguez@atheros.com, technoboy85@gmail.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/13 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2009-11-12 at 23:18 +0100, Matteo Croce wrote:
>
>> kmalloc-64 is definitely getting fat
>
> Is it the same with ath5k?
>
> I don't see any allocations like that in mac80211.
>
> johannes
>

Yes, I tested ath5k/mac80211 and ath9k/mac80211 and both show the same problem
whereas madwifi/net80211, tested with the same module, has not memory leak.

Lorenzo

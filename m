Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:25791 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbYBSWZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 17:25:20 -0500
Received: by el-out-1112.google.com with SMTP id v27so1143132ele.23
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2008 14:25:19 -0800 (PST)
Subject: Re: [PATCH 00/13] o11s: mesh interface support for mac80211
From: Luis Carlos Cobo <luisca@cozybit.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890802191359o5c6a869i559a4f6aeb686772@mail.gmail.com>
References: <47a78212.15588c0a.27b2.61d2@mx.google.com>
	 <1202343188.9965.41.camel@johannes.berg>
	 <1203455604.31736.23.camel@localhost>
	 <43e72e890802191359o5c6a869i559a4f6aeb686772@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 14:26:52 -0800
Message-Id: <1203460012.31736.38.camel@localhost> (sfid-20080219_222524_437815_49513B05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-19 at 16:59 -0500, Luis R. Rodriguez wrote:
> > Currently, bss are sorted by ssid, bssid and frequency.
> 
> I wouldn't use "sort" here but instead "are made unique". As John has

Right, sorry for the imprecise use of the word.

> The key'ing of the BSSes based on BSSID/freq/SSID was just a to deal
> with an issue, how about we just detect if a beacon is from a mesh and
> if so add it to the list using another type of rule? Since we have no
> BSSID/SSID strange issue we don't have to apply that rule there.

Sounds good.


> > but the user chooses an ad-hoc network), change the type of the
> > interface and the proceed to connect. Am I right?
> 
> Hopefully nothing will be added via wext, but instead nl80211/cfg80211.

Hopefully, but last time I checked (10 days ago) it looked like there
was no work in progress to implement scanning via nl80211.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46001
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbXH3Rze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 13:55:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: bad mac80211/softmac/xfs interaction
Date: Thu, 30 Aug 2007 19:53:51 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1188397301.8048.2.camel@johannes.berg>
In-Reply-To: <1188397301.8048.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708301953.51926.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 August 2007 16:21:41 Johannes Berg wrote:
> Hey,
> 
> When I run something like "make" at the same time as my zd1211rw dongle
> with softmac using wpa_supplicant, associated with an AP on the same
> machine (!) using b43/hostapd, and then hit ctrl-c to abort
> wpa_supplicant, I fairly frequently have some code try to run a freed
> work struct.
> 
> Does anybody have an idea what could be the cause of this? I suppose the
> XFS interaction is there so that the work item isn't immediately done,
> and I can't reproduce easily if I don't run them both on the same
> machine.
> 
> For completeness, log below.

related to this one?
http://bugzilla.kernel.org/show_bug.cgi?id=8937

-- 
Greetings Michael.

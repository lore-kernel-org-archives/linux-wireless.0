Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24847 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYIPIBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 04:01:30 -0400
To: "Helmut Schaa" <hschaa@suse.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
References: <200809151416.07552.hschaa@suse.de>
	<200809151634.06448.hschaa@suse.de>
	<1221492529.10177.76.camel@localhost.localdomain>
	<200809151845.35841.hschaa@suse.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Sep 2008 11:00:55 +0300
In-Reply-To: <200809151845.35841.hschaa@suse.de> (ext Helmut Schaa's message of "Mon\, 15 Sep 2008 18\:45\:35 +0200")
Message-ID: <87vdwwzfig.fsf@nokia.com> (sfid-20080916_100132_276719_07558395)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <hschaa@suse.de> writes:

> Ok, I'll sum that up. Moving the policy into user space is a good
> thing if the quality values are comparable. Once mac80211 recognices
> a noticable quality change we could use IWEVQUAL to notify user
> space about it. Furthermore (if desired) the signal could be
> extended to not only report a value between 0 and 100 but could also
> contain flags indicating lost beacons, excessive retries etc.

I guess that would work.

-- 
Kalle Valo

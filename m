Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaANIo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 03:44:29 -0500
Message-ID: <1389689064.4333.0.camel@jlt4.sipsolutions.net> (sfid-20140114_094432_246368_B1B4B723)
Subject: Re: [PATCH] mac80211: add tracing for ieee80211_sta_set_buffered
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 09:44:24 +0100
In-Reply-To: <87ob3fnkly.fsf@purkki.adurom.net> (sfid-20140114_072800_240207_84377A2B)
References: <1389006270-21768-1-git-send-email-johannes@sipsolutions.net>
	 <87ob3fnkly.fsf@purkki.adurom.net> (sfid-20140114_072800_240207_84377A2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 08:27 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > This is useful for debugging issues with drivers using this
> > function (erroneously), so add tracing for the API call.
> >
> > Change-Id: Ice9d7eabb8fecbac188f0a741920d3488de700ec
> 
> Extra change id.
> 
> (Sending just in case you missed it)

I did, yuck.

johannes



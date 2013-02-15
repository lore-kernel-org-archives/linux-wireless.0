Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gecko.sbs.de ([194.138.37.40]:31745 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab3BOI5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 03:57:35 -0500
Message-ID: <1360918601.12484.6.camel@djensen-laptop> (sfid-20130215_095738_385911_A3239FDB)
Subject: Re: [RFC] iw: support split wiphy dump
From: Dennis H Jensen <dennis.h.jensen@siemens.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Feb 2013 09:56:41 +0100
In-Reply-To: <1360856422.8210.2.camel@jlt4.sipsolutions.net>
References: <1360855759-2377-1-git-send-email-johannes@sipsolutions.net>
	 <1360856049-2546-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_163418_636491_ECBFFDA6) <1360856422.8210.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 16:40 +0100, Johannes Berg wrote:
> On Thu, 2013-02-14 at 16:34 +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > This adds support for the new split wiphy dump,
> > it only uses it for "iw list", not for "info"
> > though, so far. Using it for "info" would mean
> > querying the kernel capability first and then
> > using get/dump (with filter) depending on that.
> 
> Dennis, are you up for implementing this in wpa_supplicant?

Great, this will solve it. I can handle the wpa_supplicant; give me a
couple of days to get it sorted.

What's the procedure, do I post to both lists or just the hostap?

//Dennis


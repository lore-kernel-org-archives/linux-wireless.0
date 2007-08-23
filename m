Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53530 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760844AbXHWOgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 10:36:49 -0400
Subject: Re: [PATCH 1/2] mac80211:  Remove ieee80211_privacy_mismatch
From: Volker Braun <vbraun@physics.upenn.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1187878586.4314.22.camel@johannes.berg>
References: <1187406018.30247.17.camel@thinkpad>
	 <20070818034146.GC1415@jm.kir.nu>  <1187787855.4314.6.camel@johannes.berg>
	 <1187805455.9845.104.camel@carrot.hep.upenn.edu>
	 <1187878586.4314.22.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 10:36:48 -0400
Message-Id: <1187879808.27317.13.camel@carrot.hep.upenn.edu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-23 at 16:16 +0200, Johannes Berg wrote:
> However, I'm trying to figure out why wpa_supplicant
> doesn't tell mac80211 it's doing key management in your case.

Yes, I also looked quickly into wpa_supplicant but so far haven't found
out why the key management is not set. I'll try to debug that further...

> > ------------------ snip --------------------------------
> > Mixed Cells Mode
> thanks for that, where did you get that from?

I found it at Dell's support page:

http://www.support.dell.com/support/edocs/network/P94583/en/security.htm




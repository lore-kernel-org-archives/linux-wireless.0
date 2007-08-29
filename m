Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49704
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXH2Rvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 13:51:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 AP mode powersaving problems?
Date: Wed, 29 Aug 2007 19:50:03 +0200
Cc: Kalle Valo <Kalle.Valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
References: <1186990509.27916.38.camel@johannes.berg> <1188349109.7837.147.camel@johannes.berg> <1188382312.19891.7.camel@johannes.berg>
In-Reply-To: <1188382312.19891.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708291950.04237.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 August 2007 12:11:52 Johannes Berg wrote:
> On Wed, 2007-08-29 at 10:37 +0200, Johannes Berg wrote:
> 
> > I'll update the specs to indicate that
> 
> I wrote http://bcm-v4.sipsolutions.net/802.11/TX#QueueSelection and
> updated the ObjectMemory page for the SHM stuff wrt. DTIM period etc.

Hm, I am wondering why this "more data" thing is needed.
Driver sets it and fw clears it? So why set it at all?

-- 
Greetings Michael.

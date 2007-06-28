Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60389
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761964AbXF1Igh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 04:36:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Thu, 28 Jun 2007 10:35:54 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706251628.00838.mb@bu3sch.de> <200706271840.09719.flamingice@sourmilk.net>
In-Reply-To: <200706271840.09719.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706281035.54448.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 June 2007 03:40:05 Michael Wu wrote:
> On Monday 25 June 2007 07:28, Michael Buesch wrote:
> > +#define IEEE80211_CONF_SHORT_PREAMBLE	(1<<3) /* use short preamble
> > +						* with IEEE 802.11b */
> Shouldn't this be more of a "short preamble allowed" bit rather than "use 
> short preamble"? After all, short preamble is usually configured per frame.
> 
> -Michael Wu
> 

Well, I copied the comment from existing mac80211 code.
Sure, we can change it.

-- 
Greetings Michael.

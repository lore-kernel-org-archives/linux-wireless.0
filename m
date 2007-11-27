Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbXK0FNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 00:13:30 -0500
Date: Mon, 26 Nov 2007 21:12:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail -
 net/wireless driver
Message-Id: <20071126211205.9ce0d3b2.akpm@linux-foundation.org> (sfid-20071127_051333_593085_00DAC8D5)
In-Reply-To: <200711270006.20431.flamingice@sourmilk.net>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<200711262337.49178.flamingice@sourmilk.net>
	<20071126205559.dfaf1a56.akpm@linux-foundation.org>
	<200711270006.20431.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Nov 2007 00:06:16 -0500 Michael Wu <flamingice@sourmilk.net> wrote:

> On Monday 26 November 2007 23:55:59 Andrew Morton wrote:
> > On Mon, 26 Nov 2007 23:37:48 -0500 Michael Wu <flamingice@sourmilk.net> 
> wrote:
> > > On Monday 26 November 2007 21:54:23 Andrew Morton wrote:
> > > > Why not just rename one of them?
> > >
> > > Wait, why does renaming just one of them work?
> >
> > umm, well I assume that the failure is because we're trying to link two
> > identically-named symbols together?
> But there's more than one pair..
> 
> rtl8180_rtl8225.h:
> void rtl8225_rf_init(struct ieee80211_hw *);
> void rtl8225z2_rf_init(struct ieee80211_hw *);
> void rtl8225_rf_stop(struct ieee80211_hw *);
> 
> rtl8187_rtl8225.h:
> void rtl8225_rf_init(struct ieee80211_hw *);
> void rtl8225z2_rf_init(struct ieee80211_hw *);
> void rtl8225_rf_stop(struct ieee80211_hw *);

Oh.  Someone must have trimmed the error messages.

Sigh, whatever.  Please fix it all when convenient...

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:24646 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761410AbYHESUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 14:20:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so973485nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 11:20:10 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Date: Tue, 5 Aug 2008 20:44:34 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Will Dyson <will.dyson@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808041636.41189.IvDoorn@gmail.com> <200808052030.05748.IvDoorn@gmail.com> <1217959883.3603.50.camel@johannes.berg>
In-Reply-To: <1217959883.3603.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808052044.34747.IvDoorn@gmail.com> (sfid-20080805_202028_869059_4F944454)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 August 2008, Johannes Berg wrote:
> On Tue, 2008-08-05 at 20:30 +0200, Ivo van Doorn wrote:
> 
> > > > =============================================
> > > > [ INFO: possible recursive locking detected ]
> > > > 2.6.27-rc1-rt2-wl #1
> > > > ---------------------------------------------
> > > > rt61pci/4405 is trying to acquire lock:
> > > >  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> > > > ieee80211_scan_completed+0x172/0x320 [mac80211]
> > > > 
> > > > but task is already holding lock:
> > > >  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> > > > ieee80211_scan_completed+0x172/0x320 [mac80211]
> > > > 
> > > 
> > > I get that same lockdep warning when using the mainline kernel with b43. It 
> > > doesn't seem to cause any problems.
> > 
> > Sounds like a mac80211 bug then, can't find something obvious at first glance,
> > but perhaps Johannes has an idea?
> 
> I ignore everything with the TX lock in it because those have been
> wrongly annotated in a bunch of versions, including -rc1 afaik.

Heh ok. :)

Ivo

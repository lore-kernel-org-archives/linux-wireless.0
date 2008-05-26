Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:58620 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYEZFmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 01:42:32 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1136172fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2008 22:42:30 -0700 (PDT)
Date: Mon, 26 May 2008 08:42:26 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
	flamingice@sourmilk.net
Subject: Re: regression iwl3945/mac80211: association times out since
	2.6.26-rc1
Message-ID: <20080526054040.GA7207@robinhood.home> (sfid-20080526_074235_995217_D1E652A8)
References: <20080520184859.GA8168@robinhood.home>
	<20080521054743.GA9910@robinhood.home>
	<20080524182852.GA9722@robinhood.home>
	<1ba2fa240805241624t4999d108uef78b30408a5c545@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240805241624t4999d108uef78b30408a5c545@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 25, 2008 at 02:24:28AM +0300, Tomas Winkler wrote:
> On Sat, May 24, 2008 at 9:29 PM, Michael S. Tsirkin
> <m.s.tsirkin@gmail.com> wrote:
> > On Wed, May 21, 2008 at 08:47:44AM +0300, Michael S. Tsirkin wrote:
> >> FYI, I created an item in bugzilla to track this
> >> http://bugzilla.kernel.org/show_bug.cgi?id=10765
> >
> > As requested, more configuration and log files have been attached
> > to this item.
> 
> It looks like also this issue should be fixed by ' mac80211: reorder
> channel and freq reporting in wext scan report' patch.
> http://article.gmane.org/gmane.linux.kernel.wireless.general/15177
> Please try.
> Thanks
> Tomas

I can confirm that the patch linked above has solved the regression for me.
Is it queued for 2.6.26?

-- 
MST

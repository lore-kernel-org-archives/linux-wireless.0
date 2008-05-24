Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:48336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783AbYEXS3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 14:29:33 -0400
Received: by fg-out-1718.google.com with SMTP id 19so760135fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2008 11:29:32 -0700 (PDT)
Date: Sat, 24 May 2008 21:29:27 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
	flamingice@sourmilk.net
Subject: Re: regression iwl3945/mac80211: association times out since
	2.6.26-rc1
Message-ID: <20080524182852.GA9722@robinhood.home> (sfid-20080524_202937_250788_753BCDF9)
References: <20080520184859.GA8168@robinhood.home>
	<20080521054743.GA9910@robinhood.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080521054743.GA9910@robinhood.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 08:47:44AM +0300, Michael S. Tsirkin wrote:
> FYI, I created an item in bugzilla to track this
> http://bugzilla.kernel.org/show_bug.cgi?id=10765

As requested, more configuration and log files have been attached
to this item.


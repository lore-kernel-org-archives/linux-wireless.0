Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.229]:17103 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbYEUFrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 01:47:52 -0400
Received: by hu-out-0506.google.com with SMTP id 19so4659846hue.21
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 22:47:50 -0700 (PDT)
Date: Wed, 21 May 2008 08:47:45 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
	flamingice@sourmilk.net
Subject: Re: regression iwl3945/mac80211: association times out since
	2.6.26-rc1
Message-ID: <20080521054743.GA9910@robinhood.home> (sfid-20080521_074756_624287_2B6B331F)
References: <20080520184859.GA8168@robinhood.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080520184859.GA8168@robinhood.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI, I created an item in bugzilla to track this
http://bugzilla.kernel.org/show_bug.cgi?id=10765

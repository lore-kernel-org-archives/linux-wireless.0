Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49712
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753509AbYAZNwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:52:49 -0500
Date: Sat, 26 Jan 2008 05:53:02 -0800 (PST)
Message-Id: <20080126.055302.166290523.davem@davemloft.net> (sfid-20080126_135251_721283_726C78A3)
To: linville@tuxdriver.com
Cc: torvalds@linux-foundation.org, mb@bu3sch.de, dcbw@redhat.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080125224631.GH14687@tuxdriver.com>
References: <20080125211815.GF14687@tuxdriver.com>
	<alpine.LFD.1.00.0801251354350.5056@hp.linux-foundation.org>
	<20080125224631.GH14687@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 25 Jan 2008 17:46:31 -0500

> Given that we don't have a CONFIG_MUST_ALIGN at present, I'm not sure
> it is worth adding one for either an iwlwifi fix or a mac80211 one.
> Or are there other issues that might be resolved or aided by such
> a definition?  It doesn't seem to have been needed so far.

We do have a need, look at the drivers like Tulip that
encode this into a big list of architecture ifdef checks.

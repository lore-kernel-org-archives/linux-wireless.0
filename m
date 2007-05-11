Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44406 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153AbXEKKVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 06:21:41 -0400
Date: Fri, 11 May 2007 12:21:35 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
Message-ID: <20070511122135.108b60eb@logostar.upir.cz>
In-Reply-To: <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com>
References: <464253CE.2030504@linux.intel.com>
	<20070510132756.2ca660a0@midnight.suse.cz>
	<46434596.6010908@linux.intel.com>
	<20070510194233.335004b7@griffin.suse.cz>
	<46437DC8.2060805@linux.intel.com>
	<20070510212355.6c13cde8@griffin.suse.cz>
	<1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 11 May 2007 01:24:58 +0300, Tomas Winkler wrote:
> The code is available why should it be paste it to the email.

Because the development happens on this list and in wireless-dev git tree
and not somewhere on sourceforge?

Thinking about it, I'd say it's time for Intel to stop hiding in the corner
and send iwlwifi driver for a review and inclusion in wireless-dev. I think
something like this could work:

1. send the driver (without all things that would require changing of the
   mac80211 stack) and ask for a review

2. when all comments are addressed, ask for inclusion in wireless-dev

3. send a patch that modifies/add a feature to mac80211 _together_ with a
   second patch that makes use of such feature in iwlwifi

4. repeat 3 for each new/modified feature you want in mac80211

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs

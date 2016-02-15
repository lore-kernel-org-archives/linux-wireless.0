Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42727 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbcBOKOg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 05:14:36 -0500
Message-ID: <1455531273.5210.2.camel@sipsolutions.net> (sfid-20160215_111439_916705_4650E97F)
Subject: Re: [PATCH 2/3] iwlwifi: mvm: move TX PN assignment for TKIP to the
 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Eliad Peller <eliad@wizery.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Peller, EliadX" <eliadx.peller@intel.com>
Date: Mon, 15 Feb 2016 11:14:33 +0100
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA1338D@hasmsx107.ger.corp.intel.com>
References: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com>
	 <CANUX_P3Ybzowsf3Kg7TFhtpq+H4bDWMswrGHhkrvHKtnZaEVhA@mail.gmail.com>
	 <1455477875.2564.0.camel@sipsolutions.net>
	 <0BA3FCBA62E2DC44AF3030971E174FB32EA122F3@hasmsx107.ger.corp.intel.com>
	 <CAB3XZEdXC1jG5FXOPu-seT2pVzKa6Sg15s_YTeMnULi7vBgL5A@mail.gmail.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32EA1331F@hasmsx107.ger.corp.intel.com>
	 <CAB3XZEeYfYaHUOcBjxpD5+_4YGRemm6W+YDRksPjxBqCxvTPtw@mail.gmail.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32EA1338D@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-15 at 09:24 +0000, Grumbach, Emmanuel wrote:
> 
> It doesn't feel right to remove this function in mac80211-next.git
> and
> touch 3 drivers along the way, but I don't mind. Johannes, what do
> you say?

I don't see any problem with that? I've touched far more drivers (like
"every single one") when doing API updates :)

johannes

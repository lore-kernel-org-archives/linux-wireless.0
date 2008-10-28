Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbYJ1CT6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 22:19:58 -0400
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
From: Zhu Yi <yi.zhu@intel.com>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W.Linville" <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20081028025947.6c9c3274@mtlp.12.dimension>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	 <1225157618.2917.215.camel@debian.sh.intel.com>
	 <20081028025947.6c9c3274@mtlp.12.dimension>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 10:19:50 +0800
Message-Id: <1225160390.2917.221.camel@debian.sh.intel.com> (sfid-20081028_032003_106014_FCF6A1BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-27 at 18:59 -0700, Mirco Tischler wrote:
> > Looks good so far. But I failed to see what are you trying to
> connect?
> > Can you try "iwconfig wlan0 channnel <> essid <>"?
> Sorry. I should have supplied that information on the first try. The
> network is
> a standard WPA-protected G-band network at 2.437Ghz (channel 6).
> That command seems to help a bit. At least I was able to connect more
> often after executing it.

You don't need this command if wpa_supplicant works correctly. Is it a
hidden SSID AP?

Thanks,
-yi


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4879 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYKWW2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 17:28:49 -0500
Date: Sun, 23 Nov 2008 17:27:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Xu, Martin" <martin.xu@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"yang.y.yi@gmail.com" <yang.y.yi@gmail.com>,
	Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
	Jothikumar Mothilal <Jothikumar.Mothilal@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"Liu, Bing Wei" <bing.wei.liu@intel.com>,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>,
	"Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts per second at idle
Message-ID: <20081123222735.GB30249@hash.localnet> (sfid-20081123_232854_078564_29DFF254)
References: <bug-11749-13098@http.bugzilla.kernel.org/> <20081013150525.884BC108058@picon.linux-foundation.org> <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com> <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com> <b6c5339f0811130826p138ceae1hc6fc55bf7cf5c595@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D410CD777@pdsmsx503.ccr.corp.intel.com> <20081117133737.GA16412@hash.localnet> <9F0C1DB20AFA954FA1DA05309350433D41183AB4@pdsmsx503.ccr.corp.intel.com> <20081121202734.GC3540@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081121202734.GC3540@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2008 at 03:27:34PM -0500, John W. Linville wrote:
> > +static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> > +				struct ieee80211_vif *vif,
> > +				struct ieee80211_bss_conf *bss_conf,
> > +				u32 changes);
> 
> This patch defines ath5k_bss_info_changed, but doesn't use it.
> Is that really what you meant to do?

The first version of this patch set .bss_info_changed but it looks
like it got lost along the way.  Martin?

-- 
Bob Copeland %% www.bobcopeland.com


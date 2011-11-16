Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1KPH5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 02:57:23 -0500
Subject: Re: [PATCH] compat-wireless: add iwlwifi RCU compat
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1321429868.4773.6.camel@jlt3.sipsolutions.net> (sfid-20111116_085115_766845_F180BE5F)
References: <1318925272.3958.5.camel@jlt3.sipsolutions.net>
	 (sfid-20111018_100806_415009_C55DA618)  <1321429868.4773.6.camel@jlt3.sipsolutions.net>
	 (sfid-20111116_085115_766845_F180BE5F)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 08:57:20 +0100
Message-ID: <1321430240.4773.11.camel@jlt3.sipsolutions.net> (sfid-20111116_085726_407466_B1150327)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 08:51 +0100, Johannes Berg wrote:
> On Tue, 2011-10-18 at 10:07 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > We need to patch the new kfree_rcu() reference in
> > iwlwifi out and add rcu_barrier() to make it safe.
> 
> Ping. Need to apply this now, see
> http://mid.gmane.org/20111116104133.E58B.2E210E2F@nifty.com

Or do Hauke's other proposed kfree_rcu backport of course :-)

johannes


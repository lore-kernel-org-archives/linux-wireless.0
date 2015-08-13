Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47101 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbbHMJc2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 05:32:28 -0400
Message-ID: <1439458345.2114.14.camel@sipsolutions.net> (sfid-20150813_113231_054279_298C911A)
Subject: Re: [PATCH 06/10] mac80211: remove
 ieee80211_aes_cmac_calculate_k1_k2()
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 11:32:25 +0200
In-Reply-To: <1437140619.1933.21.camel@sipsolutions.net> (sfid-20150717_154345_215380_045B45B2)
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1436359312-26533-7-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150708_144254_350866_ECD76AB0) <1437140619.1933.21.camel@sipsolutions.net>
	 (sfid-20150717_154345_215380_045B45B2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-17 at 15:43 +0200, Johannes Berg wrote:
> On Wed, 2015-07-08 at 15:41 +0300, Emmanuel Grumbach wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The iwlwifi driver was the only driver that used this, but as
> > it turns out it never needed it, so we can remove it.
> > 
> I'm not applying this for now since it depends on the iwlwifi patch 
> to remove usage thereof :)
> 
> I think we said I'd apply that one also through my tree, but since 
> it's not urgent I'll sort it out later.
> 

Which I've done now - so this is also in now.

johannes

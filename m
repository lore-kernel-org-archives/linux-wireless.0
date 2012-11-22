Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:58022
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932624Ab2KVU5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:57:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20653.45231.513974.419869@gargle.gargle.HOWL> (sfid-20121122_215756_668077_58EA2AA4)
Date: Thu, 22 Nov 2012 10:27:19 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add debugfs callbacks for station
 addition/removal
In-Reply-To: <1353494712.10444.20.camel@jlt4.sipsolutions.net>
References: <1353381362-437-1-git-send-email-sujith@msujith.org>
	<1353494712.10444.20.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2012-11-20 at 08:46 +0530, Sujith Manoharan wrote:
> > From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> > 
> > Provide drivers with hooks to create debugfs files when
> > a new station is added. This would help drivers to take
> > advantage of mac80211's station list infrastructure and not maintain
> > tedious station management code internally.
> 
> Applied.

Thanks for fixing the ifdef oversight.

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45266 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426848AbcBRU1p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:27:45 -0500
Message-ID: <1455827262.2084.31.camel@sipsolutions.net> (sfid-20160218_212811_135414_76CE5855)
Subject: Re: [RFC 0/2] mac80211: add support for ht_caps mcs rxmask override
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric DEBARGE <cedric.debarge@acksys.fr>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Date: Thu, 18 Feb 2016 21:27:42 +0100
In-Reply-To: <cover.1454685673.git.cedric.debarge@acksys.fr>
References: <cover.1454685673.git.cedric.debarge@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[reducing CC list]

On Fri, 2016-02-05 at 16:41 +0100, Cedric DEBARGE wrote:
> This patchset allows the ht_caps mcs rxmask to be defined on the fly.
> It applies the given rxmask to all available bands.
> 
> This is actually limited to radio cards without internal rc.
> 

Curious. Ben Greear had suggested something that seems rather similar.
What are you working on that you need this?

I think my comments to him apply to this too - see the thread at
http://thread.gmane.org/gmane.linux.kernel.wireless.general/143789

johannes

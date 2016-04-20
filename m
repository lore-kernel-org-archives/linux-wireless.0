Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58649 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbcDTT7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 15:59:32 -0400
Message-ID: <1461182362.2176.19.camel@sipsolutions.net> (sfid-20160420_215936_843302_BCD737E0)
Subject: Re: RSS configuration in iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Sharon, Sara" <sara.sharon@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 21:59:22 +0200
In-Reply-To: <1461171915.17112.7.camel@decadent.org.uk> (sfid-20160420_190523_576134_E6CFB6DA)
References: <1461164882.28559.61.camel@decadent.org.uk>
	 <1461166207.19157.1.camel@intel.com>
	 <1461167278.28559.63.camel@decadent.org.uk>
	 <1461169379.19157.7.camel@intel.com>
	 <1461171915.17112.7.camel@decadent.org.uk>
	 (sfid-20160420_190523_576134_E6CFB6DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-20 at 18:05 +0100, Ben Hutchings wrote:
> 
> I see.  You could make this work when the interface is down and
> return -EBUSY if the interface is up.
> 

It's slightly more complicated, since it doesn't just affect a single
netdev but possibly more than one (since the table is shared by all
virtual interfaces) - but yes, it could be done.

johannes

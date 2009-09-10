Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:60057 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbZIJSnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 14:43:16 -0400
From: Frans Pop <elendil@planet.nl>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: iwlagn: order 2 page allocation failures
Date: Thu, 10 Sep 2009 20:43:13 +0200
Cc: Mel Gorman <mel@csn.ul.ie>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	"cl@linux-foundation.org" <cl@linux-foundation.org>,
	"Krauss, Assaf" <assaf.krauss@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
References: <200909060941.01810.elendil@planet.nl> <20090910090206.GA22276@csn.ul.ie> <1252606547.30150.304.camel@rc-desk>
In-Reply-To: <1252606547.30150.304.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909102043.17883.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 September 2009, reinette chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> Date: Wed, 9 Sep 2009 15:41:00 -0700
> Subject: [PATCH] iwlwifi: reduce noise when skb allocation fails

Looks good to me (from a user's perspective).
IIUC the first message is now only displayed if IWL debugging is 
explicitly enabled, and the second only if there really is danger of it 
affecting data transfer and has been made more informative too.

It seems to me that, with debugging enabled, the "Failed to allocate SKB 
buffer." message may get repeated, but I guess that's minor.

One nitpick. As you've made the message into sentences, "Only %u free 
buffers remaining" should IMO also end with a period.

Thanks,
FJP

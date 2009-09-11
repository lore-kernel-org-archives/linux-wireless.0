Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36773 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbZIKQN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 12:13:58 -0400
Subject: Re: iwlagn: order 2 page allocation failures
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>,
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
In-Reply-To: <20090911084542.GA32497@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl>
	 <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>
	 <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>
	 <1252526738.30150.91.camel@rc-desk> <20090910090206.GA22276@csn.ul.ie>
	 <1252606547.30150.304.camel@rc-desk>  <20090911084542.GA32497@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 09:14:00 -0700
Message-Id: <1252685640.30150.391.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-09-11 at 01:45 -0700, Mel Gorman wrote:
> Otherwise, it looks just the finest and I think it will address the
> problem to some extent - in that it won't print alarming messages when
> they are not needed.
> 
> The additional changes with respect to GFP_ATOMIC are optional. Whether
> you do it or not.
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>

Thank you very much. I'll make the changes you suggested.

Reinette



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbZFDPzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 11:55:39 -0400
Subject: Re: [RFT 1/3] iwlwifi: port to cfg80211 rfkill
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1244106196.22576.65.camel@johannes.local>
References: <20090602111027.460530075@sipsolutions.net>
	 <20090602111111.956543636@sipsolutions.net>
	 <1244063570.17790.203.camel@rc-desk>
	 <1244106196.22576.65.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 09:02:36 -0700
Message-Id: <1244131356.20900.3.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, 2009-06-04 at 02:03 -0700, Johannes Berg wrote:
> > In summary the testing went very well. There was that one gpf that
> > clouded the testing a bit. I have no idea how it can be connected to the
> > rfkill work though because the error appear to be contained in the
> > sony-laptop module.
> 
> That looks like an error in sony-laptop, indeed. Should we go ahead with
> the iwlwifi part then?

Please do. Please feel free to add my "tested-by" when you do so. Is it
possible to get this into 2.6.31?

I'll submit a bug for the issue I saw in sony-laptop and try to help to
get it resolved independently.

Reinette



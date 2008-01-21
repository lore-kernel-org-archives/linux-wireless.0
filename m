Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:56872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbYAUPva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 10:51:30 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 04/12] iwlwifi: document scan command
Date: Mon, 21 Jan 2008 07:51:28 -0800
Message-ID: <4220499A1B034C4FA93B547BA01E1FF0025F5928@orsmsx413.amr.corp.intel.com> (sfid-20080121_155138_021931_9EDD52CC)
In-reply-to: <1200688782.5716.38.camel@johannes.berg>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com> <1200361585-31801-2-git-send-email-reinette.chatre@intel.com> <1200361585-31801-3-git-send-email-reinette.chatre@intel.com> <1200361585-31801-4-git-send-email-reinette.chatre@intel.com> <1200361585-31801-5-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022705_457944_D9860755) <1200441772.5887.167.camel@johannes.berg> <4220499A1B034C4FA93B547BA01E1FF001746541@orsmsx413.amr.corp.intel.com> <1200688782.5716.38.camel@johannes.berg>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: Friday, January 18, 2008 3:40 PM
> To: Cahill, Ben M
> Cc: Chatre, Reinette; linville@tuxdriver.com; 
> linux-wireless@vger.kernel.org; Zhu, Yi
> Subject: RE: [PATCH 04/12] iwlwifi: document scan command
> 
> 
> > > iwl4965 will transmit a probe request and go to the next channel 
> > > before hostapd sends the probe response, iwl4965 still sees the 
> > > response, but the b43 card never sees the ACK because 
> it's receiver 
> > > isn't quite as good as the iwl4965 receiver.
> > 
> > I'm not sure of the history of the dwell time values, but it's an 
> > attempt to balance reliability of scan vs. speed of scan.  
> The active 
> > dwell times are, of course, more speed-aggressive than the 
> passive ones.
> > Would you be willing to experiment with your setup, and try some 
> > different values?
> 
> Sure, can do that next week, do I just change the defines at 
> the top of the file?

Yes.

-- Ben --

> 
> johannes
> 

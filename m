Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:39859 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZCNRJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:09:27 -0400
Message-ID: <49BBE4A0.3060901@nokia.com> (sfid-20090314_180930_320559_508095FE)
Date: Sat, 14 Mar 2009 19:08:48 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL in	iwl_adjust_beacon_interval
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com>	 <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk>	 <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>	 <20090221003133.GB3890@tuxdriver.com>	 <1235443093.4455.77.camel@johannes.local>	 <20090225014454.GA3577@tuxdriver.com> <1237046388.5235.82.camel@johannes.local>
In-Reply-To: <1237046388.5235.82.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Kalle, I suspect that your beacon offload will require something like
> holding on to BSS structs too, is that correct?

My current solution is just to disable beacon filtering (and power save) 
whenever we are scanning. That way beacon filtering doesn't interfere 
scanning in anyway.

I'm about to send v2 of my beacon filtering patches next.

Kalle


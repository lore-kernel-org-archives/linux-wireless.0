Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22286 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbXJJR4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 13:56:46 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] mac80211/iwlwifi + hidden ssids
Date: Wed, 10 Oct 2007 10:54:46 -0700
Message-ID: <4616099B20F1F24C8ADC5B1BFE2A0F88037D3DBF@fmsmsx413.amr.corp.intel.com> (sfid-20071010_185650_233106_447DB7B4)
In-Reply-To: <4616099B20F1F24C8ADC5B1BFE2A0F88037D3D8B@fmsmsx413.amr.corp.intel.com>
References: <470C9F28.1070803@gmail.com><20071010130653.GB5962@tuxdriver.com><1192026847.9739.4.camel@localhost.localdomain><f6ca9fed0710100757gbcd364esdd94f114cfe1019@mail.gmail.com><1192028866.9739.32.camel@localhost.localdomain><20071010152027.GF5962@tuxdriver.com> <4616099B20F1F24C8ADC5B1BFE2A0F88037D3D8B@fmsmsx413.amr.corp.intel.com>
From: "Ferguson, Dana R" <dana.r.ferguson@intel.com>
To: "Ferguson, Dana R" <dana.r.ferguson@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>
Cc: <linux-wireless@vger.kernel.org>,
	"ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

I bit more info. I am hearing it is a Cisco CCX feature and will not be
included in the open source code.

Dana

-----Original Message-----
From: ipw3945-devel-bounces@lists.sourceforge.net
[mailto:ipw3945-devel-bounces@lists.sourceforge.net] On Behalf Of
Ferguson, Dana R
Sent: Wednesday, October 10, 2007 10:43 AM
To: John W. Linville; Dan Williams
Cc: linux-wireless@vger.kernel.org; ipw3945-devel
Subject: Re: [ipw3945-devel] mac80211/iwlwifi + hidden ssids

Hi,

Engineers here have brought to my attention that this has been going on
for several projects and has been reported in Bugzilla on 2915, 3945 and
now the current. I can't get into the old data bases to provide bug
ID's. So I can't provide more details.

I am wondering why it keeps getting over looked? Have we narrowed it
down to where it is failing?

Dana
  

-----Original Message-----
From: ipw3945-devel-bounces@lists.sourceforge.net
[mailto:ipw3945-devel-bounces@lists.sourceforge.net] On Behalf Of John
W. Linville
Sent: Wednesday, October 10, 2007 8:20 AM
To: Dan Williams
Cc: linux-wireless@vger.kernel.org; ipw3945-devel
Subject: Re: [ipw3945-devel] mac80211/iwlwifi + hidden ssids

On Wed, Oct 10, 2007 at 11:07:46AM -0400, Dan Williams wrote:
> On Wed, 2007-10-10 at 16:57 +0200, dragoran wrote:

> > btw shouldn't all mac80211 drivers either work or not work because
the
> > code for this is in mac80211 and not in the drivers?
> 
> Yeah, pretty much; but each driver/firmware may handle hidden ssids
> slightly differently.  mac80211 should bring some sanity to this area,
> but I wouldn't discount variation between even mac80211 based drivers.

Hmmm...doesn't the iwlwifi firmware intercede in scanning?

John
-- 
John W. Linville
linville@tuxdriver.com

------------------------------------------------------------------------
-
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
_______________________________________________
Ipw3945-devel mailing list
Ipw3945-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/ipw3945-devel

------------------------------------------------------------------------
-
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
_______________________________________________
Ipw3945-devel mailing list
Ipw3945-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/ipw3945-devel

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbXJKECc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 00:02:32 -0400
Subject: Re: [ipw3945-devel] mac80211/iwlwifi + hidden ssids
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Ferguson, Dana R" <dana.r.ferguson@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20071010181019.GJ5962@tuxdriver.com>
References: <4616099B20F1F24C8ADC5B1BFE2A0F88037D3D8B@fmsmsx413.amr.corp.intel.com>
	 <4616099B20F1F24C8ADC5B1BFE2A0F88037D3DBF@fmsmsx413.amr.corp.intel.com>
	 <20071010181019.GJ5962@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 00:03:08 -0400
Message-Id: <1192075388.31110.11.camel@localhost.localdomain> (sfid-20071011_050236_133909_B99997A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-10 at 14:10 -0400, John W. Linville wrote:
> On Wed, Oct 10, 2007 at 10:54:46AM -0700, Ferguson, Dana R wrote:
> > Hey,
> > 
> > I bit more info. I am hearing it is a Cisco CCX feature and will not be
> > included in the open source code.
> > 
> > Dana
> 
> Huh?  I'm not sure what "it" is?  Care to elaborate?

Yeah, it's unclear.   CCX should have _nothing_ to do with hidden SSID
support since hidden SSIDs (and workarounds to support them) existed
waaay before Cisco coughed up CCX.

Dan

> I do find it dismaying to hear that Intel is holding back wireless
> compatibility features from Linux...
> 
> John


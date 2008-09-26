Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31676 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYIZFRi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 01:17:38 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1222406036.2510.521.camel@debian.sh.intel.com>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
	 <1222401242.2510.519.camel@debian.sh.intel.com>
	 <43e72e890809252113h624a8d91jd859935ae5afed10@mail.gmail.com>
	 <1222406036.2510.521.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 13:16:53 +0800
Message-Id: <1222406213.2510.523.camel@debian.sh.intel.com> (sfid-20080926_071741_796390_460CC125)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-26 at 13:13 +0800, Zhu Yi wrote:
> On Thu, 2008-09-25 at 21:13 -0700, Luis R. Rodriguez wrote:
> > 
> > CONFIG_WIRELESS_OLD_REGULATORY is a temporary solution, the right
> > solution for you is to build the regulatory domain with the provided
> > API as discussed at OLS. Additionally distributions can start picking
> > up iw and crda. I can also see NetworkManager asking the kernel to set
> > the regulatory domain just as with iw, based on the user's defined
> > country somewhere.
> 
> This is a known bug. Please read
> http://marc.info/?l=linux-wireless&m=122237262931451&w=2 and revert the
> corresponding patch.

Oops, send to the wrong address. Please ignore.

Thanks,
-yi


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56511 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbbGNUiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 16:38:13 -0400
Date: Tue, 14 Jul 2015 16:38:10 -0400
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"seth.forshee@canonical.com" <seth.forshee@canonical.com>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: Re: pull request: add -13.ucode firmware for Intel Wireless
Message-ID: <20150714203810.GM13281@merlin.infradead.org> (sfid-20150714_223817_366630_76FB673E)
References: <1434651812.4885.9.camel@intel.com>
 <1434652237.4885.16.camel@intel.com>
 <1436119980.18783.1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436119980.18783.1.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 05, 2015 at 06:13:00PM +0000, Grumbach, Emmanuel wrote:
> On Thu, 2015-06-18 at 21:30 +0300, Emmanuel Grumbach wrote:
> > Hi,
> > 
> > This is a pull request for a new version of the firmware for Intel
> > wireless devices. Note that with this new firmware, we are now adding
> > support for 3 new devices: 3165, 8260 and 4165.
> > 
> > I had sent a pull request a while ago, this one replaces the older one.
> > Since then, we have added bug fixes and we are now able to release
> > iwlwifi-8000C.ucode which support 8260 and 4165.
> > 
> > Please pull.
> 
> Any chance to get that pull request honored?
> I added the distro reps whom I know. This firmware includes quite a few
> bug fixes...
> 

Pulled, sorry, I didn't realize I was the only person doing this now...
:/

--Kyle

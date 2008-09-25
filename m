Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYIYHe5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 03:34:57 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1222245882.18015.62.camel@johannes.berg>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20080924_080231_170139_3D180880)  <1222245882.18015.62.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 15:34:18 +0800
Message-Id: <1222328058.2510.470.camel@debian.sh.intel.com> (sfid-20080925_093501_457302_4A0DE31C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-24 at 02:44 -0600, Johannes Berg wrote:
> On Wed, 2008-09-24 at 13:57 +0800, Zhu Yi wrote:
> > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > 
> > The patch adds channels sysfs entry for iwl3945. Make it consistent
> > with iwlagn.
> 
> I advocate just make it consistent by removing it entirely.

We need a way to show the channel info the card EEPROM advocated, not
the final one intersected with the regdomain. Are you suggesting a
debugfs entry?

Thanks,
-yi


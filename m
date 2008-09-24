Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYIXKyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 06:54:06 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1222245882.18015.62.camel@johannes.berg>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20080924_080231_170139_3D180880)  <1222245882.18015.62.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 06:52:10 -0400
Message-Id: <1222253530.26675.11.camel@localhost.localdomain> (sfid-20080924_125411_806521_4D41620C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-24 at 10:44 +0200, Johannes Berg wrote:
> On Wed, 2008-09-24 at 13:57 +0800, Zhu Yi wrote:
> > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > 
> > The patch adds channels sysfs entry for iwl3945. Make it consistent
> > with iwlagn.
> 
> I advocate just make it consistent by removing it entirely.
> 
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -7666,8 +7666,60 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
> >  static ssize_t show_channels(struct device *d,
> >  			     struct device_attribute *attr, char *buf)
> >  {
> > -	/* all this shit doesn't belong into sysfs anyway */

Yeah, it seems odd.

Dan



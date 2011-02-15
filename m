Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab1BOUas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 15:30:48 -0500
Subject: Re: Get/set Sensitivity for a radio?
From: wwguy <wey-yi.w.guy@intel.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D5AE1B5.8010302@candelatech.com>
References: <4D5AE1B5.8010302@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 12:28:57 -0800
Message-ID: <1297801737.4723.25.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 12:27 -0800, Ben Greear wrote:
> Hello!
> 
> I'm having no luck finding where sensitivity is set in
> net/mac80211.  Anyone know something to grep for?
> 
I am not sure mac80211 deal with sensitivity if it's what you referring
(at least not I am aware of).

in iwlwifi, driver and uCode take care of sensitivity calibration.

Wey



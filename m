Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56644 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbcCCPpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:45:05 -0500
Message-ID: <1457019901.2044.28.camel@sipsolutions.net> (sfid-20160303_164514_889776_A1EFAF7D)
Subject: Re: [PATCH] mac80211_hwsim: Set global RRM capability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Spinadel, David" <david.spinadel@intel.com>
Date: Thu, 03 Mar 2016 16:45:01 +0100
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA51497@hasmsx107.ger.corp.intel.com>
References: <1456392253-16972-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1456921458.2157.2.camel@sipsolutions.net>
	 <0BA3FCBA62E2DC44AF3030971E174FB32EA51497@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-02 at 12:36 +0000, Grumbach, Emmanuel wrote:
> > 
> I had the same thinking, but somehow people convinced me that a
> driver may prefer not to advertise this without its explicit
> consent. 

So ... What are the arguments? :)

johannes

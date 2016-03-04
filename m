Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbcCDFjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 00:39:37 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Spinadel, David" <david.spinadel@intel.com>
Subject: Re: [PATCH] mac80211_hwsim: Set global RRM capability
Date: Fri, 4 Mar 2016 05:39:32 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA55BF2@hasmsx107.ger.corp.intel.com> (sfid-20160304_063940_523192_E55422FA)
References: <1456392253-16972-1-git-send-email-emmanuel.grumbach@intel.com>
 <1456921458.2157.2.camel@sipsolutions.net>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA51497@hasmsx107.ger.corp.intel.com>
 <1457019901.2044.28.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/03/2016 05:45 PM, Johannes Berg wrote:
> On Wed, 2016-03-02 at 12:36 +0000, Grumbach, Emmanuel wrote:
>>>
>> I had the same thinking, but somehow people convinced me that a
>> driver may prefer not to advertise this without its explicit
>> consent.
>
> So ... What are the arguments? :)
>

Well.. a driver may not want to advertise it... Moot...
I guess we can / should move it to mac80211.

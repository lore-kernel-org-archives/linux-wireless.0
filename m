Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYDWV3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 17:29:17 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwl4965 regression since 2.6.24
Date: Wed, 23 Apr 2008 14:29:14 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004415BC8@orsmsx416.amr.corp.intel.com> (sfid-20080423_232954_115409_9600D9D3)
In-Reply-To: <20080423124105.GA4783@ics.muni.cz>
References: <20080423124105.GA4783@ics.muni.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>,
	<linux-kernel@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , linux-wireless-owner@vger.kernel.org  wrote:

> Hello,
> 
> as of 2.6.25 kernel, the intel driver iwl4965 has serious troubles to
> associate with AP. I must many times set essid till the
> association is done.
> 
> Moreover, it seems that it is unable to associate with
> different AP (using the
> same SSID). I must remove the module completly to be able to
> associate to the different AP. I think it is big regression.
> 

Could you please send us some logs that can help us debug this problem?
Please load the driver with debugging (modprobe iwl4965 debug=0x43ffb)
to get detailed logs and add a detailed description about what you are
trying to do with the driver as the logs are created. Also, please
consider filing a bug at http://www.intellinuxwireless.org/bugzilla/
with these logs attached.

Thanks

Reinette

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42147 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbXHBMlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 08:41:15 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] chaning mode only when interface down?
Date: Thu, 2 Aug 2007 15:41:09 +0300
Message-ID: <C07C4589BE74A34981C3C3525EE1F801024CF30B@hasmsx412.ger.corp.intel.com>
In-Reply-To: <1186058047.24230.38.camel@johannes.berg>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "dragoran" <drago01@gmail.com>, "Dan Williams" <dcbw@redhat.com>,
	<linux-wireless@vger.kernel.org>,
	"network manager" <networkmanager-list@gnome.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>-----Original Message-----
>From: Johannes Berg [mailto:johannes@sipsolutions.net]
>Sent: Thursday, August 02, 2007 3:34 PM
>To: Winkler, Tomas
>Cc: dragoran; Dan Williams; linux-wireless@vger.kernel.org; network
>manager; ipw3945-devel@lists.sourceforge.net
>Subject: RE: [ipw3945-devel] chaning mode only when interface down?
>
>On Thu, 2007-08-02 at 15:17 +0300, Winkler, Tomas wrote:
>
>> There is a definitely a known issue in the driver that we still need
to
>> resolve, but I agree with Johannes that there is a problem in design
of
>> the configuration as well.
>
>Nono, you cannot solve it in the driver. The whole design of mac80211
>mandates that assumption and I think it is a valid one to make. If
>userspace breaks because of that it's their fault.
>
I know for sure there is an issue in our driver for moving to master
(AP) mode. I'm just cleaning up this patch...

I'm really not an expert on the configuration but I think at least the
transition from STA to IBSS mode and back should be smooth without
reloading the driver. What you do if the driver is compiled to kernel
will we reboot?

I hope we are talking about the same issue here...
Thansk
Tomas

>johannes

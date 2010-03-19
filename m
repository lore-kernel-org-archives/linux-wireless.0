Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0CSQj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 12:39:27 -0400
To: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [RFC PATCH 1/2] mac80211: add interface for disabling QoS
MIME-Version: 1.0
Date: Fri, 19 Mar 2010 17:39:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20100319155749.GA4972@dhcp-lab-161.englab.brq.redhat.com>
References: <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com> <1268265597.4192.3.camel@jlt3.sipsolutions.net> <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com> <1268319960.4413.1.camel@jlt3.sipsolutions.net> <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com> <1268774282.4054.1.camel@jlt3.sipsolutions.net> <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com> <1268841106.5989.1.camel@jlt3.sipsolutions.net> <20100319105612.GA4915@dhcp-lab-161.englab.brq.redhat.com> <1269009449.11480.1.camel@jlt3.sipsolutions.net> <20100319155749.GA4972@dhcp-lab-161.englab.brq.redhat.com>
Message-ID: <b0ff25b67318cca987ea1b244b33ccf0@localhost>
Content-Type: text/plain;
 charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 19 Mar 2010 16:57:50 +0100, Stanislaw Gruszka
<sgruszka@redhat.com>
wrote:
> On Fri, Mar 19, 2010 at 07:37:29AM -0700, Johannes Berg wrote:
>> On Fri, 2010-03-19 at 11:56 +0100, Stanislaw Gruszka wrote:
>> > Add BSS_CHANGE_QOS_DISABLED flag to pass to drivers when want to
>> > disable
>> > QoS (aka WMM, WME).
>> 
>> Umm? Take another look at how the change flags etc. work
> 
> You want it that way:
>       changed |= BSS_CHANGED_QOS
>       sdata->vif.bss_conf.qos_disabled = true;
> ?

Yes.

johannes

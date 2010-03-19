Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0CSOht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 10:37:49 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: add interface for disabling QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20100319105612.GA4915@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
	 <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com>
	 <1268265597.4192.3.camel@jlt3.sipsolutions.net>
	 <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com>
	 <1268319960.4413.1.camel@jlt3.sipsolutions.net>
	 <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com>
	 <1268774282.4054.1.camel@jlt3.sipsolutions.net>
	 <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com>
	 <1268841106.5989.1.camel@jlt3.sipsolutions.net>
	 <20100319105612.GA4915@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 07:37:29 -0700
Message-ID: <1269009449.11480.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-19 at 11:56 +0100, Stanislaw Gruszka wrote:
> Add BSS_CHANGE_QOS_DISABLED flag to pass to drivers when want to disable
> QoS (aka WMM, WME).

Umm? Take another look at how the change flags etc. work

johannes


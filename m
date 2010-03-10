Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab0CJPWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 10:22:38 -0500
Date: Wed, 10 Mar 2010 16:20:25 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
Message-ID: <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 09, 2010 at 02:21:14PM +0100, Stanislaw Gruszka wrote:
> Problem is that we enable QoS queues, when AP do not send us any QoS
> parameters. I think when AP not support QoS and does not tell anything
> about that, we should not enable QoS in H/W. I prepared a draft patch,
> it fixes the issue. However I'm not sure if this is right approach,
> perhaps we should find something better.

I divide my fix into two patches. I'll send them in next emails.
If no one have objections I'll post them "officially" with -stable cc.

Stanislaw 

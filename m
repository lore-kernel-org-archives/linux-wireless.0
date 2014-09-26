Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58709 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbaIZVcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 17:32:33 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 280AA40CF8C
	for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2014 14:32:33 -0700 (PDT)
Message-ID: <5425DB70.8000404@candelatech.com> (sfid-20140926_233237_023154_795F2218)
Date: Fri, 26 Sep 2014 14:32:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless:  expose set-wiphy-name method to other
 modules.
References: <1411689584-16136-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1411689584-16136-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2014 04:59 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This will let hw-sim create wiphy objects with a specific
> name.

This has an added whitespace that should not have been included,
and next patch does not take rtnl before doing the rename.

Will test some more and re-send.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


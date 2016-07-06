Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:47710 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbcGFDWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 23:22:41 -0400
Date: Tue, 05 Jul 2016 20:22:37 -0700 (PDT)
Message-Id: <20160705.202237.33945138215381341.davem@davemloft.net> (sfid-20160706_052246_832330_D4A29367)
To: masashi.honma@gmail.com
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-audit@redhat.com, cluster-devel@redhat.com,
	johannes@sipsolutions.net, pablo@netfilter.org, kaber@trash.net,
	kadlec@blackhole.kfki.hu, dledford@redhat.com,
	sean.hefty@intel.com, hal.rosenstock@gmail.com,
	paul@paul-moore.com, eparis@redhat.com, zbr@ioremap.net,
	pshelar@nicira.com, ccaulfie@redhat.com, teigland@redhat.com,
	bsingharora@gmail.com
Subject: Re: [RFC 0/7] netlink: Add allocation flag to netlink_unicast()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
References: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masashi Honma <masashi.honma@gmail.com>
Date: Wed,  6 Jul 2016 09:28:29 +0900

> Though currently such a use case was not found, to solve potential
> issue we will add an allocation flag to netlink_unicast().

We don't solve potential issues, we solve real issues.

There is no reason to add the GFP parameter until it is actually
needed.

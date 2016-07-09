Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35809 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbcGIDyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 23:54:25 -0400
Subject: Re: [RFC 0/7] netlink: Add allocation flag to netlink_unicast()
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-audit@redhat.com, cluster-devel@redhat.com
References: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
Cc: davem@davemloft.net, johannes@sipsolutions.net,
	pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	dledford@redhat.com, sean.hefty@intel.com,
	hal.rosenstock@gmail.com, paul@paul-moore.com, eparis@redhat.com,
	zbr@ioremap.net, pshelar@nicira.com, ccaulfie@redhat.com,
	teigland@redhat.com, bsingharora@gmail.com
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <5780756A.5050405@gmail.com> (sfid-20160709_055432_260385_B7813854)
Date: Sat, 9 Jul 2016 12:54:18 +0900
MIME-Version: 1.0
In-Reply-To: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年07月06日 09:28, Masashi Honma wrote:
> Though netlink_broadcast() ...

Thanks for reply of David Miller, Eric Dumazet, David Teigrand.

On the basis of their comment, only rtnl_unicast() looks need to add gfp
flag
argument. So I will drop almost of patches except 0005.

I will send patch v2 to more limited destination.


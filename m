Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35369
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030815AbXCHWeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 17:34:19 -0500
Date: Thu, 08 Mar 2007 14:34:19 -0800 (PST)
Message-Id: <20070308.143419.75428407.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: jt@hpl.hp.com, johannes@sipsolutions.net, jkm@devicescape.com,
	mb@bu3sch.de, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, jgarzik@pobox.com, dcbw@redhat.com
Subject: Re: wireless extensions vs. 64-bit architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070308141756.efdfd6da.randy.dunlap@oracle.com>
References: <1173382802.3248.68.camel@johannes.berg>
	<20070308221128.GA24884@bougret.hpl.hp.com>
	<20070308141756.efdfd6da.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 8 Mar 2007 14:17:56 -0800

> I think that this is not actually an option since
> powerpc64 is all 32-bit userspace.
> Maybe some other arch-es are like this also (?).

sparc64 is like this too

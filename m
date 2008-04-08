Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbYDHWw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 18:52:26 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] Make IWLCORE a silent option not to confuse iwl3945 users.
Date: Tue, 8 Apr 2008 15:45:13 -0700
Message-ID: <D936D925018D154694D8A362EEB089200424D627@orsmsx416.amr.corp.intel.com> (sfid-20080408_235230_860080_2F1BEC7C)
In-Reply-To: <877if8m5zx.fsf@sparse.dyndns.org>
References: <874pakhist.fsf@sparse.dyndns.org><D936D925018D154694D8A362EEB0892004195168@orsmsx416.amr.corp.intel.com><20080408180441.GB8183@tuxdriver.com> <877if8m5zx.fsf@sparse.dyndns.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Jason Riedy" <jason@acm.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <ipw3945-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 08, 2008 1:44 PM, Jason Riedy  wrote:

> And John W. Linville writes:
>> I think it makes sense to make IWLCORE invisible, but this patch
>> seems not quite right.  I'm dropping it -- feel free to repost a
>> revised version.
> 
> I would love to, but I have no idea what the current base is.
> The net-2.6.26 branch of jgarzik/netdev-2.6.git, master of
> davem/net-2.6.26.git, and master of your 2.6.26 repo all still
> have the iwl3945 that won't compile without iwl4965.  And
> rchatre/iwlwifi-2.6.git won't merge into those without irrelevant
> conflicts. 
> 
> This is a mess.  I hope y'all can sort it out before the window
> opens.  The blinky lights are fun.

You can base your patches on either the iwlwifi-2.6 or wireless-testing
repositories that are hosted on git.kernel.org. You do not need to merge
between repositories.

Reinette


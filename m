Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16508 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYBLVrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 16:47:33 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [Ipw2100-admin] [PATCH] ipw2100/ipw2200: note firmware loadingcaveat in Kconfig help text
Date: Tue, 12 Feb 2008 13:44:48 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003A4619E@orsmsx416.amr.corp.intel.com> (sfid-20080212_214742_561491_5BBDF016)
In-Reply-To: <20080212134942.9FD589D4135@zog.reactivated.net>
References: <20080212134942.9FD589D4135@zog.reactivated.net>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Daniel Drake" <dsd@gentoo.org>, <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <ipw2100-admin@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Daniel Drake wrote:

> Most wireless drivers load their firmware at interface open time,
> which generally occurs after the filesystem is available. However,
> the ipw drivers
> load their firmware at probe time because firmware is required
> to read the
> device MAC address. When built-in, probe happens before the
> filesystem is
> available, hence device init will only complete successfully
> if the user
> has made special arrangements (including firmware plus a loader in
> the initramfs). 
> 
> Note all this in the kconfig help text for both drivers.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
> ---

Thank you very much.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

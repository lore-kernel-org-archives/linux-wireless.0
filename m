Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38009 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbXGYOXZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 10:23:25 -0400
Message-ID: <46A75CD9.9050100@garzik.org>
Date: Wed, 25 Jul 2007 10:23:21 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: yi.zhu@intel.com
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull patch-bomb for iwlwifi
References: <20070725085754.GA670@mail.intel.com>
In-Reply-To: <20070725085754.GA670@mail.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> Hi,
> 
> This patch series catches wireless-dev up to the stand-alone
> iwlwifi tree version 0.1.3.
> 
> There are totally 117 patches so I won't post them one by one on
> the list. Please find the commit series for the changes in the
> patch bomb:
> 
>     iwlwifi-efe55d8fa702a23724bf44fdd54059f8c4480941.tgz
> at
>     http://intellinuxwireless.org/iwlwifi/patches/

Based on a brief glance, patches look good to me.  Thanks!

Two suggestions:

1) You should post patches to the list for review.  Yes, even if there 
are 117 of them.  That is acceptable -- and encouraged -- mailing list 
etiquette.

2) I would recommend submitting via git.  Auke @ Intel does this with 
e100/e1000/etc. stuff and it works great.

The main suggestion is #1, since it is important to post patches to 
linux-wireless.  #2 is more in the realm of linville's preference.

	Jeff




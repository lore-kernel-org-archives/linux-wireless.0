Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gundega.hpl.hp.com ([192.6.19.190]:54107 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbXDZQrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 12:47:43 -0400
Date: Thu, 26 Apr 2007 09:46:32 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] wext: remove dead debug code
Message-ID: <20070426164632.GA22576@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070424180732.371620000@sipsolutions.net> <20070424180847.982382000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070424180847.982382000@sipsolutions.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 24, 2007 at 08:07:35PM +0200, Johannes Berg wrote:
> This patch kills a whole bunch of code that can only ever be used by
> defining some things in wext.c. Also, the things that are printed are
> mostly useless since the API is fairly well-tested.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

	Hi,

	Overall ok with the patches. Comments on a few of them...
	I personally would not remove this DEBUG code, because it
decreases the overall maitainability of the code.
	First, it does not only help to debug the API, but it can be
used to debug userspace and drivers in some extreme cases.
	Second, this debugging act as documentation. He points out
which are the important variables and how they are used at critical
points of the code.
	As this debug is localised, and compiled out, it does not
bother anybody and should stay.

	Regards,

	Jean

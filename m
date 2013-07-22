Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8469 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3GVJ47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 05:56:59 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <thomas@fjellstrom.ca>, Larry Finger <Larry.Finger@lwfinger.net>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ath: wil6210: Fix build error
Date: Mon, 22 Jul 2013 12:56:56 +0300
Message-ID: <458166038.k2AmqmisOp@lx-vladimir> (sfid-20130722_115709_456396_AB9FFD3B)
In-Reply-To: <1374457543.16248.8.camel@deadeye.wl.decadent.org.uk>
References: <1374374808-12768-1-git-send-email-Larry.Finger@lwfinger.net> <5330916.8NnOO4SNAp@lx-vladimir> <1374457543.16248.8.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 22, 2013 02:45:43 AM Ben Hutchings wrote:
> > ifeq (, $(findstring -W,$(EXTRA_CFLAGS)))
> >       subdir-ccflags-y += -Werror
> > endif
> 
> This is a pretty weird thing to do, and you've failed to account for
> -Wextra.
> 
> -Werror is generally a bad default in free software, as you have no
> control over which compiler version will be used.
> 

Well, you convinced me. I'll send patch removing -Werror.

Thanks, Vladimir

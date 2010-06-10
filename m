Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25894 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab0FJR2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 13:28:32 -0400
Subject: Re: [PATCHv4] mac80211: Fix circular locking dependency in ARP
 filter handling
From: reinette chatre <reinette.chatre@intel.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276147255.5277.34285.camel@wimaxnb.nmp.nokia.com>
References: <1276080206-29562-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1276126067.1835.15473.camel@rchatre-DESK>
	 <1276147255.5277.34285.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 10:28:31 -0700
Message-ID: <1276190911.1835.17699.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Juuso,

On Wed, 2010-06-09 at 22:20 -0700, Juuso Oikarinen wrote:
> This is curious. In your source (mine does not seem to fully match what
> you are using) what is the BUG that is getting triggered, main.c:437 ?

Strange ... in my source that is a weird line number also. I think I
know what happened ... after applying your patch my habits took over and
I only rebuilt the driver, not mac80211. I am very sorry for my previous
false report.

I rebuilt everything cleanly. After doing so I have not encountered any
issues. 

Thank you very much

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette






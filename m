Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48386 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYLJNQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 08:16:09 -0500
Subject: Re: [PATCH 1/4] iwlwifi: change email contact information
From: Marcel Holtmann <holtmann@linux.intel.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1228853086.2339.33.camel@rc-desk>
References: <> <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
	 <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
	 <1228852251.19553.125.camel@violet.holtmann.net>
	 <1228853086.2339.33.camel@rc-desk>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 14:16:02 +0100
Message-Id: <1228914962.19553.147.camel@violet.holtmann.net> (sfid-20081210_141614_819282_A7698FF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> > just double checking that "ilw" is intentional. It is kinda weird since
> > we prefix our driver with "iwl". It might be a little bit confusing.
> 
> Yes - "ilw" is intentional (not a typo). 
> 
> > 
> > Also the MODULE_AUTHOR tag should contain the maintainer information. At
> > least that is what the current consensus is. I know that the word author
> > is kinda misleading here.
> 
> The author currently contains "Intel Corporation". There are a few
> people that fulfill the maintainer role so adding a person's name here
> will not work.
> 
> Will this be acceptable:
> 
> MODULE_AUTHOR("Copyright(c) 2003-2008 Intel Corporation <ilw@linux.intel.com>")

yes this will work fine. Sorry that I wasn't clear here. I really meant
that we should add the new address also to MODULE_AUTHOR.

Regards

Marcel



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55571 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbZCBVh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 16:37:27 -0500
Subject: Re: [PATCH] iwlwifi: reduce stack size
From: reinette chatre <reinette.chatre@intel.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, Frank Seidel <frank@f-seidel.de>,
	"kernalert.de@gmail.com" <kernalert.de@gmail.com>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <49AAE132.8030403@suse.de>
References: <49AAE132.8030403@suse.de>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 13:42:13 -0800
Message-Id: <1236030133.18288.158.camel@rc-desk> (sfid-20090302_223732_008331_F7D77BDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-03-01 at 11:25 -0800, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Reduce stack memory footprint of iwlwifi.
> (From >1000 bytes for each *_table_read
> on i386 down to 32)
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>

Thank you.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette



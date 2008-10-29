Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56159 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbYJ2R33 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 13:29:29 -0400
Subject: Re: [PATCH] iwl3945: remove bogus comment
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225238548.1369.10.camel@johannes.berg>
References: <1225238548.1369.10.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 10:29:53 -0700
Message-Id: <1225301393.1115.277.camel@rc-desk> (sfid-20081029_182934_189067_97FA2727)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-28 at 17:02 -0700, Johannes Berg wrote:
> I added this comment myself, but it's clearly wrong. I had meant
> to place it in iwl_mac_add_interface, which at the time didn't
> honour the MAC address setting, but it does now.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks Johannes

ack

Reinette


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59856 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbYCYQI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 12:08:56 -0400
Message-ID: <47E92396.6070203@tiscali.nl> (sfid-20080325_160859_931865_D298E191)
Date: Tue, 25 Mar 2008 17:08:54 +0100
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) in iwl4965_is_fat_tx_allowed()
References: <47E92235.80500@tiscali.nl>
In-Reply-To: <47E92235.80500@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the triple mail, it appeared to fail twice.

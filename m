Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49170 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab2K0Izd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 03:55:33 -0500
Message-ID: <1354006493.950.52.camel@cumari.coelho.fi> (sfid-20121127_095536_800553_186116A8)
Subject: Re: [PATCH 01/11] wlcore: configure dwell times according to scan
 type
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Eliad Peller <eliad@wizery.com>
Date: Tue, 27 Nov 2012 10:54:53 +0200
In-Reply-To: <1353945950-3899-2-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
	 <1353945950-3899-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 18:05 +0200, Arik Nemtsov wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Allow configuring different dwell times to the different
> scan types (regular and scheduled).
> 
> Add new configuration entry (dwell_time_dfs) to
> conf_scan_settings, in order to allow setting
> different values for normal scan and scheduled scan.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

This patch changes the semantics of two values in the middle of the conf
struct, so WLCORE_CONF_VERSION should be increased.  Also, the wlconf
tool should be updated.

--
Luca.


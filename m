Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58554 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390Ab2K0JIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 04:08:13 -0500
Message-ID: <1354007253.950.53.camel@cumari.coelho.fi> (sfid-20121127_100818_399936_D2B81F4D)
Subject: Re: [PATCH 01/11] wlcore: configure dwell times according to scan
 type
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Eliad Peller <eliad@wizery.com>
Date: Tue, 27 Nov 2012 11:07:33 +0200
In-Reply-To: <1354006493.950.52.camel@cumari.coelho.fi>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
	 <1353945950-3899-2-git-send-email-arik@wizery.com>
	 <1354006493.950.52.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 10:54 +0200, Luciano Coelho wrote:
> On Mon, 2012-11-26 at 18:05 +0200, Arik Nemtsov wrote:
> > From: Eliad Peller <eliad@wizery.com>
> > 
> > Allow configuring different dwell times to the different
> > scan types (regular and scheduled).
> > 
> > Add new configuration entry (dwell_time_dfs) to
> > conf_scan_settings, in order to allow setting
> > different values for normal scan and scheduled scan.
> > 
> > Signed-off-by: Eliad Peller <eliad@wizery.com>
> > Signed-off-by: Arik Nemtsov <arik@wizery.com>
> > ---
> 
> This patch changes the semantics of two values in the middle of the conf
> struct, so WLCORE_CONF_VERSION should be increased.  Also, the wlconf
> tool should be updated.

Oops! Ignore this comment.  For some reason I missed the change in the
WLCORE_CONF_VERSION in this patch.  Now I see it has changed from 2 to
3.

--
Luca.


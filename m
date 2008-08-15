Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbYHOT0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 15:26:24 -0400
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
	from commit 741b4fbc44
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808152034.46346.chunkeey@web.de>
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net>
	 <200808082038.48840.chunkeey@web.de> <489EF8DE.5030801@lwfinger.net>
	 <200808152034.46346.chunkeey@web.de>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 21:26:15 +0200
Message-Id: <1218828375.3197.0.camel@localhost> (sfid-20080815_212628_067802_15AFE3C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-15 at 20:34 +0200, Chr wrote:
> Hmm, or there's something else can't count?!??
> 
> Anyway, the firmware will always assign (as in overwrite) the
> sequence number for every transmitted frame... unfortunatly
> there isn't a uniform way to disable this behaviour. 

If it always does that, then it cannot be implementing QoS properly.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38857 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYHMWMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 18:12:35 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Thu, 14 Aug 2008 00:15:23 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808110027.59918.chunkeey@web.de> <489F7410.3000507@lwfinger.net>
In-Reply-To: <489F7410.3000507@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808140015.24055.chunkeey@web.de> (sfid-20080814_001243_096045_3FCCAAB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 August 2008 01:04:48 Larry Finger wrote:
> Chr wrote:
>
> The packet size of 1408 problem is fixed here with an 'ifconfig wlan2
> mtu 1300' command. With it I can ping any length.
>
well, seems to be a firmware problem.
2.13.3.0 has no problems with all kinds of big frames on my 3887...

So, is there any knob to tell mac80211 about fragmentation from
the driver side? I'm a bit lost here what to do.

Regards,
	Chr

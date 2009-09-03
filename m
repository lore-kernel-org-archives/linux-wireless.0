Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64954 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbZICRqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 13:46:07 -0400
Subject: Re: 802.11a multicast rate setting
From: Pavel Roskin <proski@gnu.org>
To: Jinsung Lee <ljs@netsys.kaist.ac.kr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <031201ca2c47$f334bba0$d99e32e0$@kaist.ac.kr>
References: <031201ca2c47$f334bba0$d99e32e0$@kaist.ac.kr>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 13:46:00 -0400
Message-Id: <1251999960.7822.0.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-09-03 at 12:38 +0900, Jinsung Lee wrote:
> Hi, everyone.
> 
> If using ath5k or ath9k when the WLAN card supports 802.11a mode, is it
> possible to change multicast (or broadcast) rate into under 6Mbps, like the
> case of 802.11b mode?
> e.g. 1Mbps or 2Mbps.

No, such rates are not available for 802.11a.

-- 
Regards,
Pavel Roskin

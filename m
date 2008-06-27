Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42591 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbYF0TxO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 15:53:14 -0400
Subject: Re: Sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>
In-Reply-To: <486544FA.20605@lwfinger.net>
References: <486544FA.20605@lwfinger.net>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 15:53:12 -0400
Message-Id: <1214596392.9513.16.camel@dv> (sfid-20080627_215317_342275_686D252F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-27 at 14:52 -0500, Larry Finger wrote:
> While checking the rtl8187 driver for sparse warnings, I discovered these:
> 
>    CHECK   drivers/net/wireless/hostap/hostap_80211_rx.c

Larry, I'm sitting on a fix for that.  Joini was unhappy about some
radiotap changes, and I didn't have time to revisit it.  Give me two
hours, I'll send the uncontroversial parts.

-- 
Regards,
Pavel Roskin

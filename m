Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1BROue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 09:50:34 -0500
Subject: Re: [PATCH 13/14] rtlwifi: rtl8192cu: Add routine trx
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	John W Linville <linville@tuxdriver.com>,
	george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
In-Reply-To: <4D5E838F.1020707@lwfinger.net>
References: <4d5d90c9.sN3PKFogcRQR8mbQ%Larry.Finger@lwfinger.net>
	 <20110218112633.GA2270@redhat.com>  <4D5E838F.1020707@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 15:50:14 +0100
Message-ID: <1298040614.4039.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 08:34 -0600, Larry Finger wrote:

> Thanks for the comment. Unfortunately, sparse (C=2) does not find this error. 
> That test had been done and was clean. After reading your comment, I went back 
> to Documentation/sparse.txt and found the magic CF="-D__CHECK_ENDIAN__" 
> argument.

FWIW, I've been adding it to things by default -- see the bottom of
net/mac80211/Makefile for example.

johannes


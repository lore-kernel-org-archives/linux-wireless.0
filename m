Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:65003 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZFTTwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 15:52:53 -0400
Message-ID: <4A3D3E1A.1080703@lwfinger.net>
Date: Sat, 20 Jun 2009 14:52:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54: redo rx_status into skb->cb
References: <200906202113.46470.chunkeey@web.de>
In-Reply-To: <200906202113.46470.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch slightly optimizes p54_rx_data's stack and code size.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>


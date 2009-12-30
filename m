Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:43751 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZL3Ulp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 15:41:45 -0500
Received: by ey-out-2122.google.com with SMTP id 25so1806596eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 12:41:44 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/6] rt2x00: use correct headroom for transmission
Date: Wed, 30 Dec 2009 21:41:41 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>,
	Pavel Roskin <proski@gnu.org>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com> <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912302141.42177.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 December 2009, Gertjan van Wingerde wrote:
> From: Pavel Roskin <proski@gnu.org>
> 
> Use rt2x00dev->ops->extra_tx_headroom, not rt2x00dev->hw->extra_tx_headroom
> in the tx code, as the later may include other headroom not to be used in
> the chipset driver.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

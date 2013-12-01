Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:45113 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3LAAx6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 19:53:58 -0500
Message-ID: <20131201004715.11125.qmail@stuge.se> (sfid-20131201_015416_957512_3A15DE32)
Date: Sun, 1 Dec 2013 01:47:15 +0100
From: Peter Stuge <peter@stuge.se>
To: Michal Nazarewicz <mpn@google.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH] net: wireless: wcn36xx: fix potential
	NULL pointer dereference
References: <1385744870-10164-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1385744870-10164-1-git-send-email-mpn@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Nazarewicz wrote:
> +			wcn36xx_err("Run out of memory while hnadling SMD_EVENT (%d)\n",
> +				    msg_header->msg_type);

Typo hnadling.


//Peter

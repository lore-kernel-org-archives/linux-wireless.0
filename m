Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46491 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0DGQfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 12:35:42 -0400
Message-ID: <4BBCB44F.7050805@openwrt.org>
Date: Wed, 07 Apr 2010 09:35:27 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix compilation without CONFIG_ATH9K_DEBUGFS
References: <20100407052611.23065.48030.stgit@mj.roinet.com>
In-Reply-To: <20100407052611.23065.48030.stgit@mj.roinet.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-06 10:26 PM, Pavel Roskin wrote:
> Make arguments of ath_debug_stat_tx() and ath_debug_stat_rx() stubs
> match those of the same functions with CONFIG_ATH9K_DEBUGFS defined.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
Isn't that the same as what I already sent on March 31st?

- Felix

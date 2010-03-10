Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab0CKAQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 19:16:14 -0500
Date: Wed, 10 Mar 2010 15:52:20 -0800
From: Greg KH <greg@kroah.com>
To: tom.leiming@gmail.com
Cc: lrodriguez@atheros.com, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, stable@kernel.org
Subject: Re: [stable] [PATCH] ath9k: decrease size of ath9k.ko
Message-ID: <20100310235220.GA7247@kroah.com>
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 28, 2010 at 12:56:43AM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> The patch defines the fields of 'valid_single_stream' and 'valid' in
> struct ath_rate_table as char type, so decrease the size of ath9k.ko
> about 2KB.

Why would this be a -stable patch?

confused,

greg k-h

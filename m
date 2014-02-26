Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58417 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaBZMWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 07:22:20 -0500
Message-ID: <1393417325.4133.8.camel@jlt4.sipsolutions.net> (sfid-20140226_132227_464254_B337838A)
Subject: Re: [PATCH 01/14] brcmfmac: add delay before unregistering the
 network device
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Date: Wed, 26 Feb 2014 13:22:05 +0100
In-Reply-To: <530DDB91.3070807@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
						 <1393356639-19169-2-git-send-email-arend@broadcom.com>
						 (sfid-20140225_203048_842452_A39499B6) <1393358376.4170.22.camel@jlt4.sipsolutions.net>
					 <530DAECD.8010405@broadcom.com>
				 <1393406278.4133.4.camel@jlt4.sipsolutions.net>
				 <530DB3BA.20106@broadcom.com>
			 <1393407473.4133.5.camel@jlt4.sipsolutions.net>
			 <530DC56E.9040202@broadcom.com>
		 <1393413044.4133.6.camel@jlt4.sipsolutions.net>
		 <530DD131.50205@broadcom.com>
	 <1393415288.4133.7.camel@jlt4.sipsolutions.net>
	 <530DDB91.3070807@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-26 at 13:18 +0100, Arend van Spriel wrote:

> Feeling sad :-( but thanks for checking. Clearly need to look into this
> some more. John, can you please drop this one.

I think you probably still want to drop the other sleep?

johannes


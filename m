Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2204 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYGBTq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 15:46:58 -0400
Date: Wed, 2 Jul 2008 15:37:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-06-30
Message-ID: <20080702193710.GA4682@tuxdriver.com> (sfid-20080702_214702_143952_A4BE8D0E)
References: <20080630215651.GA666@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080630215651.GA666@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 05:56:51PM -0400, John W. Linville wrote:

>       iwlwifi: fix incorrect 5GHz rates reported in monitor mode

>       iwlwifi: drop skb silently for Tx request in monitor mode

It looks like these two are appropriate for 2.6.26.  Since you
haven't pulled this yet, I'll push them that way, drop them from
wireless-next-2.6, and send a new pull request.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com

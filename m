Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2BHP0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 10:26:55 -0500
Date: Wed, 8 Feb 2012 16:26:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: John Li <john.li.mediatek@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Li <chen-yang.li@mediatek.com>
Subject: Re: [rt2x00-users] [PATCH] rt2x00:Add RT5372 chipset support
Message-ID: <20120208152643.GA24072@redhat.com> (sfid-20120208_162704_013926_4939B362)
References: <1328706002-11165-1-git-send-email-john.li.mediatek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328706002-11165-1-git-send-email-john.li.mediatek@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since already Helmut complains about coding style, I'll add my
2 cents too:

On Wed, Feb 08, 2012 at 09:00:02PM +0800, John Li wrote:
> -		if (!rt2x00_rt(rt2x00dev, RT5390)) {
> +		if (!rt2x00_rt(rt2x00dev, RT5390) || 
> +			!rt2x00_rt(rt2x00dev, RT5392)) {

Please make alignments like in example below (few spaces
instead of last tab).

		if (!rt2x00_rt(rt2x00dev, RT5390) ||
		    !rt2x00_rt(rt2x00dev, RT5392)) {

Thanks
Stanislaw


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46072 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZKIQpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 11:45:12 -0500
Date: Mon, 9 Nov 2009 11:34:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, technoboy85@gmail.com
Subject: Re: [PATCH]: setting bit-rate when injecting
Message-ID: <20091109163455.GB2805@tuxdriver.com>
References: <f74418680911090807g4e83a15cr2ce21ea21a86ea23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f74418680911090807g4e83a15cr2ce21ea21a86ea23@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2009 at 05:07:20PM +0100, Lorenzo Bianconi wrote:
> I and my Matteo Croce made a patch which adds the capability
> to set the bit-rate when injecting in monitor mode.
> 
> The code parse the bit-rate field from the radiotap header and passes the info
> to the struct ieee80211_tx_info

Need a "Signed-off-by:" line.  Also, please use the "-p" option to
diff when posting patches.

I'll let Johannes comment since you are touching his baby... :-)

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

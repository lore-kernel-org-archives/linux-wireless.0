Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37684 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZIBOA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 10:00:28 -0400
Date: Wed, 2 Sep 2009 09:53:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>,
	Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] net: file_operations should be const
Message-ID: <20090902135328.GC2662@tuxdriver.com>
References: <20090902052500.808557262@vyatta.com> <20090902052538.601908379@vyatta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090902052538.601908379@vyatta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 10:25:05PM -0700, Stephen Hemminger wrote:
> All instances of file_operations should be const.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

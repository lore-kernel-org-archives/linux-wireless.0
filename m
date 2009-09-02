Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37689 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZIBOAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 10:00:30 -0400
Date: Wed, 2 Sep 2009 09:53:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>,
	Roland Dreier <rolandd@cisco.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Dhananjay Phadke <dhananjay@netxen.com>,
	David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/5] netdev: drivers should make ethtool_ops const
Message-ID: <20090902135316.GB2662@tuxdriver.com>
References: <20090902052500.808557262@vyatta.com> <20090902052538.276324751@vyatta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090902052538.276324751@vyatta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 10:25:01PM -0700, Stephen Hemminger wrote:
> No need to put ethtool_ops in data, they should be const.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

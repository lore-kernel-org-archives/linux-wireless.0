Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZL2B7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 20:59:53 -0500
Date: Mon, 28 Dec 2009 20:59:53 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jothikumar Mothilal <Jothikumar.Mothilal@Atheros.com>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat-2.6: New targets to compile bluetooth alone
Message-ID: <20091229015953.GD30201@bombadil.infradead.org>
References: <20091224112428.GA30483@atheros-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091224112428.GA30483@atheros-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 24, 2009 at 04:54:28PM +0530, Bala Shanmugam wrote:
> Compiling compat-pacakage consumes more time
> as both wireless and bluetooth modules are compiled.
> 
> For someone who wants to use bluetooth alone
> compiling and installing wireless modules is unnecessary
> and is time consuming.
> 
> New targets are declared to compile, install, uninstall, load
> and unload bluetooth modules seperately.
> 
> Usage is updated in README.
> Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>

Applied, thanks

  Luis

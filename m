Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35985 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1AFVAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:00:05 -0500
Date: Thu, 6 Jan 2011 15:51:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/32] wireless/ipw2x00: use system_wq instead of
 dedicated workqueues
Message-ID: <20110106205123.GB2411@tuxdriver.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1294062595-30097-15-git-send-email-tj@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 03, 2011 at 02:49:37PM +0100, Tejun Heo wrote:
> With cmwq, there's no reason to use separate workqueues in ipw2x00
> drivers.  Drop them and use system_wq instead.  All used work items
> are sync canceled on driver detach.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

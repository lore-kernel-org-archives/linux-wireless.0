Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55688 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab1BVUAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 15:00:33 -0500
Date: Tue, 22 Feb 2011 14:49:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, buytenh@wantstofly.org
Subject: Re: [PATCH V2 1/3] mwl8k: fix rf_antenna rx argument for AP
Message-ID: <20110222194935.GH12153@tuxdriver.com>
References: <1297982718-20377-1-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297982718-20377-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 17, 2011 at 02:45:16PM -0800, Thomas Pedersen wrote:
> From: Nishant Sarmukadam <nishants@marvell.com>
> 
> When configuring rx antennas using CMD_RF_ANTENNA, the argument input is
> the number of antennas to be enabled. For AP, we support 3 rx antennas
> and hence set the field to 3. For tx antennas, value is a bitmap, so 0x7
> enables all three.
> 
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

I hope you registered your displeasure with the firmware writers over
this API detail...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

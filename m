Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54887 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbbCCJwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:52:21 -0500
Message-ID: <1425376339.2450.29.camel@sipsolutions.net> (sfid-20150303_105230_334830_9BBC2EAC)
Subject: Re: [PATCH v2] mac80211: send station PMF configuration to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Mar 2015 10:52:19 +0100
In-Reply-To: <1425283180-3848-1-git-send-email-sjegadee@qti.qualcomm.com>
References: <1425283180-3848-1-git-send-email-sjegadee@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-02 at 13:29 +0530, SenthilKumar Jegadeesan wrote:
> Add support to provide station PMF configuration to driver.
> 
> Some device drivers, offload part of aggregation including ADDBa/DELBa
> negotiations to low layers. In such scenario, PMF configuration of
> station needs to be provided to driver to enable encryption of
> ADDBa/DELBa action frames.

Applied, with some small changes. Why did you write ADDBa rather than
AddBA? :)

johannes


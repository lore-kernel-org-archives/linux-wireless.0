Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197Ab2LFJFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 04:05:55 -0500
Date: Thu, 6 Dec 2012 10:05:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ethtool stats for wifi devices broken in 3.7.0-rc8
Message-ID: <20121206090548.GE2502@redhat.com> (sfid-20121206_100559_500644_CD26940B)
References: <50BEDFAC.9020206@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50BEDFAC.9020206@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2012 at 09:46:20PM -0800, Ben Greear wrote:
> I think the problem is that the code that assigns dev->ethtool_ops
> in net/wireless/core.c checks for existence of ops first..
> 
> But, net/core/dev.c assigns a default ethtool_ops in the alloc_netdev_mqs
> method.
> 
> Maybe cfg80211 should just always assign the value?

Care to post a patch ?

Stanislaw

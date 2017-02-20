Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48166 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbdBTJvU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 04:51:20 -0500
Message-ID: <1487582159.5474.0.camel@sipsolutions.net> (sfid-20170220_105124_329805_D67B9D8C)
Subject: Re: [RFC V2 0/3] Pre-CAC and sharing DFS state across multiple
 radios
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Feb 2017 10:15:59 +0100
In-Reply-To: <1487262275-14654-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1487262275-14654-1-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-02-16 at 21:54 +0530, Vasanthakumar Thiagarajan wrote:
> Currently irrespective of dfs domain and radar detection activity
> pre-CAC results for a wiphy are retained till the wiphy is detroyed.
> This may not be preferred in non-ETSI dfs domain where pre-CAC is not
> explicitly mentioned in the respective DFS requirement spec. This
> patch
> set modifies the current behaviour of pre-CAC for non-ETSI domain by
> giving 2 seconds grace period for dfs master interface to start
> operating
> on the CAC completed channel.
> 
> This patch set also adds support to share dfs channel state across
> multiple radios of the same regulatory configuration.
> 

Looks fine to me - please resend as PATCH.

johannes

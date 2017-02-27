Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36686 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751562AbdB0N45 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 08:56:57 -0500
Message-ID: <1488201414.28431.1.camel@sipsolutions.net> (sfid-20170227_145700_784271_519A0120)
Subject: Re: [PATCH v2] mac80211: fix mesh fail_avg check
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Mon, 27 Feb 2017 14:16:54 +0100
In-Reply-To: <1487191610-20948-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1487191610-20948-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-15 at 12:46 -0800, Rajkumar Manoharan wrote:
> Mesh failure average never be more than 100. Only in case of
> fixed path, average will be more than threshold limit (95%).
> With recent EWMA changes it may go upto 99 as it is scaled to
> 100. It make sense to return maximum metric when average is
> greater than threshold limit.

Applied, thanks.

johannes

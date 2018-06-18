Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58184 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935389AbeFRUpG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 16:45:06 -0400
Message-ID: <1529354704.3092.39.camel@sipsolutions.net> (sfid-20180618_224531_135826_D4735EDD)
Subject: Re: [PATCH] cfg80211: Add cumulative channel survey dump support.
From: Johannes Berg <johannes@sipsolutions.net>
To: vnaralas@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Mon, 18 Jun 2018 22:45:04 +0200
In-Reply-To: <ebf1c95acb34649b3d2a5435142dc06a@codeaurora.org>
References: <1526980556-26707-1-git-send-email-vnaralas@codeaurora.org>
         <1527069282.3759.16.camel@sipsolutions.net>
         <ebf1c95acb34649b3d2a5435142dc06a@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-05-31 at 14:36 +0530, vnaralas@codeaurora.org wrote:
> On 2018-05-23 15:24, Johannes Berg wrote:
> > On Tue, 2018-05-22 at 14:45 +0530, Venkateswara Naralasetty wrote:
> > > This patch provides support to send accumulated survey data to
> > > user if low level drivers provides non-accumulated survey data.
> > 
> > I think the commit log should say what you need this for?
> > 
> > It's simultaneously a new flag, and a lot of code, but it's not clear
> > what the point is?
> > 
> > johannes
> 
> I will sent next version of patch with updated commit log.
> 
> Providing you the earlier discussion of this patch to give quick 
> overview about this patch.
> https://patchwork.kernel.org/patch/9701459/

Haha. I guess it's too long ago :)

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42364 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752217AbeEGTot (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 15:44:49 -0400
Message-ID: <1525722286.22388.5.camel@sipsolutions.net> (sfid-20180507_214452_939373_A6E9E8E9)
Subject: Re: [PATCH] mesh: don't process mesh channel switch unless csa ie
 provided
From: Johannes Berg <johannes@sipsolutions.net>
To: peter.oh@bowerswilkins.com, linux-wireless@vger.kernel.org
Date: Mon, 07 May 2018 21:44:46 +0200
In-Reply-To: <1524857196-29399-1-git-send-email-peter.oh@bowerswilkins.com> (sfid-20180427_212657_786960_82D0DC24)
References: <1524857196-29399-1-git-send-email-peter.oh@bowerswilkins.com>
         (sfid-20180427_212657_786960_82D0DC24)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-04-27 at 12:26 -0700, peter.oh@bowerswilkins.com wrote:
> From: Peter Oh <peter.oh@bowerswilkins.com>
> 
> There is no meaning to call ieee80211_mesh_process_chnswitch
> without CSA IE provided, since the function will always return error.

I'm not convinced, an extended channel switch element might be present
instead?

johannes

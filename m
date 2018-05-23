Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40798 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932288AbeEWJyp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 05:54:45 -0400
Message-ID: <1527069282.3759.16.camel@sipsolutions.net> (sfid-20180523_115455_174267_C8DA2C31)
Subject: Re: [PATCH] cfg80211: Add cumulative channel survey dump support.
From: Johannes Berg <johannes@sipsolutions.net>
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 23 May 2018 11:54:42 +0200
In-Reply-To: <1526980556-26707-1-git-send-email-vnaralas@codeaurora.org>
References: <1526980556-26707-1-git-send-email-vnaralas@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-22 at 14:45 +0530, Venkateswara Naralasetty wrote:
> This patch provides support to send accumulated survey data to
> user if low level drivers provides non-accumulated survey data.

I think the commit log should say what you need this for?

It's simultaneously a new flag, and a lot of code, but it's not clear
what the point is?

johannes

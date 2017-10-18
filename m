Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54206 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759065AbdJRKfl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 06:35:41 -0400
Message-ID: <1508322936.2674.19.camel@sipsolutions.net> (sfid-20171018_123544_067744_EB380892)
Subject: Re: [PATCH V6 1/5] mac80211: Enable TDLS peer buffer STA feature
From: Johannes Berg <johannes@sipsolutions.net>
To: yintang@qti.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Oct 2017 12:35:36 +0200
In-Reply-To: <1508133633-23214-2-git-send-email-yintang@qti.qualcomm.com> (sfid-20171016_075844_306502_036ED199)
References: <TDLS for ath10k patches V6>
         <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com>
         <1508133633-23214-2-git-send-email-yintang@qti.qualcomm.com>
         (sfid-20171016_075844_306502_036ED199)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-16 at 14:00 +0800, yintang@qti.qualcomm.com wrote:
> From: Yingying Tang <yintang@qti.qualcomm.com>
> 
> Enable TDLS peer buffer STA feature.
> Set extended capability bit to enable buffer STA when driver
> support it.

It would help if you could (build) test your changes :-)

johannes

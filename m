Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44729 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686Ab3CYVfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 17:35:46 -0400
Received: by mail-wg0-f46.google.com with SMTP id fg15so1037135wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 14:35:45 -0700 (PDT)
Date: Mon, 25 Mar 2013 22:35:27 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	fengguang.wu@intel.com
Subject: Re: [PATCH v2 0/3] mac80211: Enable VHT for non chanctxes drivers
Message-ID: <20130325213527.GA32362@gobelin> (sfid-20130325_223550_695438_1D38B61E)
References: <1364244705-31108-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1364244705-31108-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 25, 2013 at 09:51:42PM +0100, Karl Beldan wrote:
> 
> Fengguang's build with v1 yields kernel-doc warnings.
> This v2 replaces the @channel+@channel_type kernel-doc entries in 
> struct ieee80211_conf with an @chandef.
> 
Just saw you had already fixed that in your wip branch, thanks.

 
Karl

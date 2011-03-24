Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42195 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1CXKEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 06:04:13 -0400
Received: by iyb26 with SMTP id 26so9491618iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 03:04:13 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19851.5836.555228.325971@gargle.gargle.HOWL>
Date: Thu, 24 Mar 2011 15:32:52 +0530
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: cleanup few redundant macros
In-Reply-To: <4D8B130E.6090307@atheros.com>
References: <1300957576-2734-1-git-send-email-mshajakhan@atheros.com>
	<19851.4373.967588.536327@gargle.gargle.HOWL>
	<4D8B130E.6090307@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi wrote:
> > There's a reason for this: 8813262ea79acf9daa0e03901bdfe93db4dc4ca5
> > If channel handling has been cleaned up since then, this can be removed.
> >    
> Oh Ok thanks, I will resend the patch without that change.
> but anyway CHANNEL_G is defined as (CHANNEL_2GHZ|CHANNEL_OFDM).

Commit 8813262ea79acf9daa0e03901bdfe93db4dc4ca5 doesn't make much sense.
Your change looks correct.

Sujith

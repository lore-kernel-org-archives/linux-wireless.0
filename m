Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36947 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0I3M7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 08:59:22 -0400
Date: Tue, 28 Sep 2010 15:47:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2] ath9k : Fix for displaying the channel number
Message-ID: <20100928194742.GB5307@tuxdriver.com>
References: <1284739766-31231-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1284739766-31231-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 09:39:26PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> In the ath9k debugging feature 'wiphy' the current channel used by the
> station is incorrectly displayed.This is because the channels available
> are sequentially mapped from numbers 0 to 37.This mapping cannot be
> changed as the channel number is also used as an index for an array of
> structures in struct ath9k_channel channels[38] .
>           This fix solves the above problem by calculating the channel
> number from center frequency.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

What was this patch based against?  It doesn't seem to apply anymore...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

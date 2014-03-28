Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaC1NAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:00:43 -0400
Message-ID: <1396011639.4175.18.camel@jlt4.sipsolutions.net> (sfid-20140328_140047_516513_101E2AD3)
Subject: Re: [PATCH v2 2/7] mac80211: make check_combinations() aware of
 chanctx reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 14:00:39 +0100
In-Reply-To: <1395409941-26303-3-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145810_696819_386DE3AD)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145810_696819_386DE3AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:52 +0100, Michal Kazior wrote:

> +	/* if chanctx has in-place reservation then consider only the future
> +	 * radar_detect. multi-vif reservation is deferred so ignore assigned
> +	 * vifs. it is impossible for new vifs to be bound to an in-place
> +	 * reserved chanctx so consistency is guranteed */

typo, guaranteed; also, */ should be on a new line in both styles

johannes


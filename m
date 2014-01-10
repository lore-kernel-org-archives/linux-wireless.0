Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAJIsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 03:48:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W1Xlf-0001ln-7K
	for linux-wireless@vger.kernel.org; Fri, 10 Jan 2014 09:48:39 +0100
Message-ID: <1389343717.4507.2.camel@jlt4.sipsolutions.net> (sfid-20140110_094918_452525_015490F4)
Subject: Re: [PATCH 4/4] mac80211: handle MMPDUs at EOSP correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 10 Jan 2014 09:48:37 +0100
In-Reply-To: <1389271882-15806-5-git-send-email-johannes@sipsolutions.net> (sfid-20140109_135134_403566_BE4C5D03)
References: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
	 <1389271882-15806-5-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140109_135134_403566_BE4C5D03)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 13:51 +0100, Johannes Berg wrote:

> +			} else {
> +				/* FIXME: do we need to set more-data? */
> +				need_null = true;
> +				num++;
> +			}

I'll change this to set the more-data bit.

johannes


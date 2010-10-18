Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58176 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab0JRUpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 16:45:11 -0400
Date: Mon, 18 Oct 2010 16:34:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
Subject: Re: [PATCH 2/3 V2] b43: N-PHY: define registers names for 2056 radio
Message-ID: <20101018203405.GB2443@tuxdriver.com>
References: <1287322732-13306-3-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1287322732-13306-3-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 17, 2010 at 03:38:51PM +0200, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Henry Ptasinski <henryp@broadcom.com>
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Nohee Ko <noheek@broadcom.com>
> ---
> V2: changed defines prefix from RADIO_ to B as correctly suggested by Stefanik.
> 
> John: in case you got lost the correct order of patches is following:
> 
> [PATCH 1/4 resend] b43: N-PHY: replace N-specific radio_chanspec with common code
> [PATCH 2/4 resend] b43: N-PHY: fix typo: read table when caching IQ LO calibration (do not write)
> [PATCH 3/4] b43: N-PHY: put radio-specific code in separated file
> [PATCH 4/4] b43: N-PHY: put 2056-radio's specific code in separated file
> 
> [PATCH 1/3] b43: N-PHY: define channel table struct for rev3+ devices
> [PATCH 2/3 V2] b43: N-PHY: define registers names for 2056 radio
> [PATCH 3/3] b43: N-PHY: add 2056 radio channels tables
> 
> PATCH 1/3 got some discussion but we decided it's OK.

Thanks for the update.  In the future, please also try to post
replacement patches as a reply to the patch they are replacing.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

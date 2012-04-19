Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43485 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab2DSNy6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:54:58 -0400
Subject: Re: [PATCH] iwlwifi: add option to disable 5GHz band
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1334830280-3019-1-git-send-email-sgruszka@redhat.com>
References: <1334830280-3019-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Apr 2012 06:50:22 -0700
Message-ID: <1334843422.27767.151.camel@wwguy-huron> (sfid-20120419_155508_379162_01BDB5AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Thu, 2012-04-19 at 12:11 +0200, Stanislaw Gruszka wrote:
> There are various problems happened on 5GHz band not observed on
> 2.4 GHz (microcode errors, queue stuck, etc... ) . Also roaming
> between 5GHz AP and 2GHz does not work very well. To workaround
> the problems add option to disable 5GHz support. This will help
> on environments where APs are dual-band, and devices will not try
> to associate on band where issues happen.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
I will push into iwlwifi tree, run regression test, then push together
with our internal patches if it is ok for you

Thanks
Wey 


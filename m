Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43218 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab0IHRxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 13:53:03 -0400
Subject: Re: [PATCH v1 0/8] SDIO Runtime PM Support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
In-Reply-To: <1283858949-11073-1-git-send-email-ohad@wizery.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 10:52:24 -0700
Message-ID: <1283968344.9120.22.camel@capsicum>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-07 at 13:29 +0200, ext Ohad Ben-Cohen wrote:
> This patchset introduces runtime PM support to SDIO cards.

I guess this whole patchset should be pulled via the mmc tree, since
there are more mmc patches, if that's fine with Andrew.

I haven't checked the mmc patches, since I'm not very familiar with that
area, but the wl1271 driver change is ack from me.

-- 
Cheers,
Luca.


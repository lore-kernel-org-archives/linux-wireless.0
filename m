Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47664 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZC3RnF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:43:05 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] rfkill: remove deprecated state constants
Date: Mon, 30 Mar 2009 10:42:54 -0700
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1238159566.4452.2.camel@johannes.local> <1238405566.24972.16.camel@johannes.local>
In-Reply-To: <1238405566.24972.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903301042.55352.inaky@linux.intel.com> (sfid-20090330_194307_404422_CD418F8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 March 2009, Johannes Berg wrote:
> I only did superficial review, but these constants are stupid
> to have and without proper warnings nobody will review the
> code anyway, no amount of shouting will help.
>
> Also fix wimax to use correct states.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

Let's push these changes through your tree; it's going to be
hell to coordinate otherwise, anyway.


-- 
Inaky

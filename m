Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab0IFHkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 03:40:52 -0400
Date: Mon, 6 Sep 2010 09:37:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/13] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100906073714.GD3024@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
 <1283526293.5211.18.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283526293.5211.18.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 03, 2010 at 08:04:53AM -0700, Guy, Wey-Yi wrote:
> A lot of changes, great jobs. How much test you done for different
> devices? Scan is a very important function and I am also not expert in
> this area.

I tested only on 3945. I will fix problems from patch 2 and 7-8, do 
additional tests on other devices that I have (4965 and 5300) and will
repost soon.

Thanks
Stanislaw

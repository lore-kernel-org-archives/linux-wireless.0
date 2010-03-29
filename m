Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0C2NQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 09:16:14 -0400
Subject: Re: [PATCH v2 3/3] mac80211: enable QoS explicitly in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
In-Reply-To: <1269857916-4440-3-git-send-email-sgruszka@redhat.com>
References: <1269857916-4440-1-git-send-email-sgruszka@redhat.com>
	 <1269857916-4440-2-git-send-email-sgruszka@redhat.com>
	 <1269857916-4440-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 15:16:08 +0200
Message-ID: <1269868568.4131.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 12:18 +0200, Stanislaw Gruszka wrote:
> Enable QoS explicitly, when user space AP program will setup a QoS
> queues. Currently this is not needed as iwlwifi not work in AP mode
> and no other driver implement enable/disable QoS.

Shouldn't this be part of patch 1? Does IBSS/mesh support QoS?

johannes


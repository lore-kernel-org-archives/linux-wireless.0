Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:52614 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2DSUsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 16:48:39 -0400
Date: Thu, 19 Apr 2012 16:48:36 -0400 (EDT)
Message-Id: <20120419.164836.2265850910226208256.davem@davemloft.net> (sfid-20120419_224843_312294_E454E475)
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org, david.spinadel@intel.com
Subject: Re: [PATCH] update for net-next: iwlwifi: Remove inconsistent and
 redundant declaration
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334867760-2815-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334867760-2815-1-git-send-email-wey-yi.w.guy@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Do not put "update for net-next: " in the Subject line, that doesn't
belong it the commit message and I would have to edit that out.

You also got the netdev address wrong, I've removed it from the CC:,
fix it up in your resubmission.


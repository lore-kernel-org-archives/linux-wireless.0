Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaAWPo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:44:57 -0500
Message-ID: <1390491891.4142.25.camel@jlt4.sipsolutions.net> (sfid-20140123_164500_032696_B7DB95A7)
Subject: Re: [PATCH 1/2] cfg80211: fix scan done race
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 16:44:51 +0100
In-Reply-To: <1390382059-16689-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1390382059-16689-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 11:14 +0200, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>

Applied both. If anyone is wondering why Emmanuel is sending my own
patches to me, it's just because of our workflow and the fact that we
ran into this bug and needed to fix it in our internal tree.

johannes


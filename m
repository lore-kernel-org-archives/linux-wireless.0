Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:56085 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaFKXeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 19:34:17 -0400
Date: Thu, 12 Jun 2014 09:34:07 +1000
From: James Cameron <quozl@laptop.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: Linux 3.15: WLAN regression on WRL54GL/B43?
Message-ID: <20140611233407.GA13823@us.netrek.org> (sfid-20140612_013423_695157_72AF0A79)
References: <20140611230513.GC913@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140611230513.GC913@drone.musicnaut.iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check that the driver reports the channel the probe was heard on?

Another driver hit this and was fixed:

	at76c50x: fix scan does not work with latest mac80211

-- 
James Cameron
http://quozl.linux.org.au/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab0JFJaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:30:22 -0400
Subject: Re: [PATCH 1/6] mac80211: reduce number of
 __ieee80211_scan_completed calls
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
References: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 11:30:12 +0200
Message-ID: <1286357412.3655.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series looks nicer, thanks!

I haven't really closely reviewed the resulting code after your patches,
but I'll trust you on it :-)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes


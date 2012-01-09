Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2AINFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 08:05:41 -0500
Subject: Re: [PATCH 2/2] iw: remove ifdefs for mcs mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1325793490-21501-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1325793490-21501-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 14:05:39 +0100
Message-ID: <1326114339.3451.26.camel@jlt3.sipsolutions.net> (sfid-20120109_140544_355404_1370D7DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-05 at 20:58 +0100, Simon Wunderlich wrote:
> These are enums, not defines. Therefore the ifdef check can never be
> true.

The original idea was that in nl80211.h you do

#define FOO FOO

(like we already have for a few things) to trigger the ifdef, but I
don't really care.

johannes


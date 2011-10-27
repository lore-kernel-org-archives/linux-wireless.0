Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1J0TaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 15:30:17 -0400
Subject: Re: [PATCHv2] mac80211: Allow noack flag overwrite for injected
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1317296545-4463-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110929_134257_662432_DC8DED82)
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	 <1317296545-4463-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20110929_134257_662432_DC8DED82)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 21:30:13 +0200
Message-ID: <1319743813.32221.3.camel@jlt3.sipsolutions.net> (sfid-20111027_213023_007728_671F4CBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-29 at 13:42 +0200, Helmut Schaa wrote:
> Allow injected unicast frames to be sent without having to wait
> for an ACK.

Did you ever have a hostapd patch for this?

johannes


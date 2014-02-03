Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaBCOrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 09:47:07 -0500
Message-ID: <1391438820.4488.25.camel@jlt4.sipsolutions.net> (sfid-20140203_154720_742196_93BEF7E0)
Subject: Re: [PATCH v8] mac80211: Update opmode during adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 15:47:00 +0100
In-Reply-To: <1391435084-17883-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140203_144514_551996_0CAFAD54)
References: <1391435084-17883-1-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20140203_144514_551996_0CAFAD54)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 14:44 +0100, Marek Kwaczynski wrote:
> Update Operating mode is needed when User Space received Assoc
> Request contains Operating mode notification element.

Applied, in a slightly edited version.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaA2Mqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:46:52 -0500
Message-ID: <1390999610.4143.10.camel@jlt4.sipsolutions.net> (sfid-20140129_134655_743737_E80D9458)
Subject: Re: [PATCH] cfg80211: set preset_chandef after channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Jan 2014 13:46:50 +0100
In-Reply-To: <1390570161-25041-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140124_142936_087909_DB42CC45)
References: <1390570161-25041-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140124_142936_087909_DB42CC45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 14:29 +0100, Janusz Dziedzic wrote:
> Set preset_chandef in channel switch notification.
> In other case we will have old preset_chandef.

Applied.

johannes


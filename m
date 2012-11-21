Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2KUKon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 05:44:43 -0500
Message-ID: <1353494712.10444.20.camel@jlt4.sipsolutions.net> (sfid-20121121_114446_537763_DE0731C8)
Subject: Re: [PATCH] mac80211: Add debugfs callbacks for station
 addition/removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Nov 2012 11:45:12 +0100
In-Reply-To: <1353381362-437-1-git-send-email-sujith@msujith.org>
References: <1353381362-437-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 08:46 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Provide drivers with hooks to create debugfs files when
> a new station is added. This would help drivers to take
> advantage of mac80211's station list infrastructure and not maintain
> tedious station management code internally.

Applied.

johannes


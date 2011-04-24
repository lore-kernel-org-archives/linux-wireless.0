Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1DXNgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 09:36:31 -0400
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	L.Kriara@sms.ed.ac.uk
In-Reply-To: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 15:36:25 +0200
Message-ID: <1303652185.3603.0.camel@jlt3.sipsolutions.net> (sfid-20110424_153645_857465_48CFCCB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 17:25 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> this will be useful when the device is operating in AP/Ad-Hoc/Mesh
> mode

Fine with me, but this counts for all virtual interfaces.

johannes



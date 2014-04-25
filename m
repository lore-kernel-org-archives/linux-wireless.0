Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaDYPob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:31 -0400
Message-ID: <1398440002.4152.18.camel@jlt4.sipsolutions.net> (sfid-20140425_174557_280695_0880A997)
Subject: Re: [PATCH 08/12] cfg80211: change function name
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Apr 2014 17:33:22 +0200
In-Reply-To: <d399a064105f6250cf64d1147452e8f53b09a43d.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065519_411477_80F48DB3)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <d399a064105f6250cf64d1147452e8f53b09a43d.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065519_411477_80F48DB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> Name wiphy_to_rdev is more accurate to describe what the function
> does, i.e., return a pointer pointing to struct
> cfg80211_registered_device.

Applied.

johannes


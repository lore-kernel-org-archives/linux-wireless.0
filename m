Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaDYPob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:31 -0400
Message-ID: <1398439946.4152.17.camel@jlt4.sipsolutions.net> (sfid-20140425_174523_875874_D656501A)
Subject: Re: [PATCH 07/12] cfg80211: change pointer name
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Apr 2014 17:32:26 +0200
In-Reply-To: <232462c1fa7d8bf4bb2f81db0cd678ddf5a52451.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065515_832231_BB831954)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <232462c1fa7d8bf4bb2f81db0cd678ddf5a52451.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065515_832231_BB831954)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> Name "dev" is too common and ambiguous, let all the pointer name
> pointing to struct cfg80211_registered_device be "rdev". This can
> improve code readability and consistency(since other places have
> already called it rdev).

Applied.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3HWN1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:27:42 -0400
Message-ID: <1377264455.14021.30.camel@jlt4.sipsolutions.net> (sfid-20130823_152745_802145_9C762356)
Subject: Re: [PATCH v3] mac80211: only respond to probe request with mesh ID
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Fri, 23 Aug 2013 15:27:35 +0200
In-Reply-To: <1377192538-5563-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130822_192909_416620_2B5728D1)
References: <1377192538-5563-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130822_192909_416620_2B5728D1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-22 at 10:28 -0700, Chun-Yeow Yeoh wrote:
> From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
> 
> Previously, the mesh STA responds to probe request from legacy STA
> but now it will only respond to legacy STA if the legacy STA does include 
> the specific mesh ID or wildcard mesh ID in the probe request.

Applied.

johannes


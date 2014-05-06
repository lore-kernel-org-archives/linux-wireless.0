Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaEFOqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 10:46:11 -0400
Message-ID: <1399387552.4218.47.camel@jlt4.sipsolutions.net> (sfid-20140506_164615_120466_982FE7D9)
Subject: Re: [PATCH v4 5/5] cfg80211: remove channel_switch combination check
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Tue, 06 May 2014 16:45:52 +0200
In-Reply-To: <1397051137-26201-6-git-send-email-michal.kazior@tieto.com> (sfid-20140409_155201_550625_89450455)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-6-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140409_155201_550625_89450455)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 15:45 +0200, Michal Kazior wrote:
> Make the driver responsible for making sure it is
> capable of performing the switch. It might as well
> accept a request but then disconnect an interface
> if some requirements are not met.
> 
> In that case userspace should be prepared for an
> appropriate event (AP/IBSS/mesh being stopped/left).

Also makes sense, but I'm not sure if this relies on any previous
patches, so I won't apply it for now.

The other three I don't think will apply anyway though.

johannes


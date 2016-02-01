Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53897 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbcBANBm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 08:01:42 -0500
Message-ID: <1454331700.3211.4.camel@sipsolutions.net> (sfid-20160201_140145_157343_18D83EEB)
Subject: Re: [PATCH] mac80211: minstrel: Scale expected_throughput by 10
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Sven Eckelmann <sven@open-mesh.com>,
	linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de,
	nbd@nbd.name
Date: Mon, 01 Feb 2016 14:01:40 +0100
In-Reply-To: <20160201125853.GA12011@prodigo> (sfid-20160201_140055_590809_FBCE6C74)
References: <1454329450-31527-1-git-send-email-sven@open-mesh.com>
	 <1454329837.3211.2.camel@sipsolutions.net> <7460390.ua0GvOE4DE@bentobox>
	 <1454331473.3211.3.camel@sipsolutions.net> <20160201125853.GA12011@prodigo>
	 (sfid-20160201_140055_590809_FBCE6C74)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-01 at 20:58 +0800, Antonio Quartulli wrote:
> 
> Should we first fix the bug introduced by 6a27b2c40b48 and then (with
> another
> patch) improve this by changing the factor from 10 to 16 ?
> The latter is going to be a bigger change because we need to make
> sure that the
> value exported via station_info gets still scaled to kbps.
> 

Ok, I guess that makes sense.

johannes


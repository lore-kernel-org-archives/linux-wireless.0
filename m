Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3JNHvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 03:51:14 -0400
Message-ID: <1381736749.13092.2.camel@jlt4.sipsolutions.net> (sfid-20131014_095117_498933_76C9498C)
Subject: Re: [PATCH] mac80211: fix crash if bitrate calculation goes wrong
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>
In-Reply-To: <1381499323-6502-1-git-send-email-johannes@sipsolutions.net> (sfid-20131011_154850_844212_E7EE972C)
References: <1381499323-6502-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131011_154850_844212_E7EE972C)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Oct 2013 09:45:49 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 15:48 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If a frame's timestamp is calculated, and the bitrate
> calculation goes wrong and returns zero, the system
> will attempt to divide by zero and crash. Catch this
> case and print the rate information that the driver
> reported when this happens.

Applied.

johannes


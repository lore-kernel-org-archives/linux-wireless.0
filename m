Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3KKNqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 08:46:01 -0500
Message-ID: <1384177555.14334.14.camel@jlt4.sipsolutions.net> (sfid-20131111_144605_865754_10864BF4)
Subject: Re: [PATCH] mac80211: add generic cipher scheme support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>
Date: Mon, 11 Nov 2013 14:45:55 +0100
In-Reply-To: <1383735753-5973-1-git-send-email-johannes@sipsolutions.net> (sfid-20131106_120243_114995_CE755B19)
References: <1383735753-5973-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131106_120243_114995_CE755B19)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 12:02 +0100, Johannes Berg wrote:
> From: Max Stepanov <Max.Stepanov@intel.com>
> 
> This adds generic cipher scheme support to mac80211, such schemes
> are fully under control by the driver. On hw registration drivers
> may specify additional HW ciphers with a scheme how these ciphers
> have to be handled by mac80211 TX/RR. A cipher scheme specifies a
> cipher suite value, a size of the security header to be added to
> or stripped from frames and how the PN is to be verified on RX.

Applied.

johannes


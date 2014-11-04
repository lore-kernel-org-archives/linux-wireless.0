Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52687 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaKDKRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 05:17:55 -0500
Message-ID: <1415096272.2064.14.camel@sipsolutions.net> (sfid-20141104_111800_185237_CC938328)
Subject: Re: [PATCH v2] mac80211: Increase uapsd max SP frames number
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 04 Nov 2014 11:17:52 +0100
In-Reply-To: <1415093584-12767-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1415093584-12767-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-04 at 11:33 +0200, Emmanuel Grumbach wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> Deliver up to 128 frames during SP instead of 8 if unlimited
> max SP is specified during association.
> 8 was just an arbitrary value, so is 128 since unlimited can
> be any number.
> However for large traffic bursts, increasing this value looks
> reasonable. Also, it seems that a few certification tests
> expect more frames to be delivered during SP.

Applied.

johannes


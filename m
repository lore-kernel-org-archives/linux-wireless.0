Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3GYHx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jul 2013 03:53:27 -0400
Message-ID: <1374738804.8827.4.camel@jlt4.sipsolutions.net> (sfid-20130725_095330_511327_81378172)
Subject: Re: [PATCH 1/2] regulatory: use correct regulatory initiator on
 wiphy register
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 25 Jul 2013 09:53:24 +0200
In-Reply-To: <1374413809-26005-1-git-send-email-arik@wizery.com> (sfid-20130721_154507_440351_5B8F6C3E)
References: <1374413809-26005-1-git-send-email-arik@wizery.com>
	 (sfid-20130721_154507_440351_5B8F6C3E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-07-21 at 16:36 +0300, Arik Nemtsov wrote:
> The current regdomain was not always set by the core. This causes
> cards with a custom regulatory domain to ignore user initiated changes
> if done before the card was registered.

Applied, thanks.

johannes


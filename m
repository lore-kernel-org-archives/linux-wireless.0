Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab3KMS2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:28:05 -0500
Message-ID: <1384367281.14578.17.camel@jlt4.sipsolutions.net> (sfid-20131113_192809_320866_76C3E666)
Subject: Re: [PATCH 1/2] mac80211: enable easier manipulation of VHT
 beamforming caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Wed, 13 Nov 2013 19:28:01 +0100
In-Reply-To: <1384193641-25813-1-git-send-email-egrumbach@gmail.com> (sfid-20131111_191408_620949_5C286C46)
References: <1384193641-25813-1-git-send-email-egrumbach@gmail.com>
	 (sfid-20131111_191408_620949_5C286C46)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-11 at 20:14 +0200, Emmanuel Grumbach wrote:
> From: Eyal Shapira <eyal@wizery.com>
> 
> Introduce shift and mask defines for beamformee STS cap and number
> of sounding dimensions cap as these can take any 3 bit value.
> While at it also cleanup an unrequired parenthesis.

Applied both.

johannes


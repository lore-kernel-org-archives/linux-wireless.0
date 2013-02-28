Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab3B1WNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:13:09 -0500
Message-ID: <1362089584.8330.6.camel@jlt4.sipsolutions.net> (sfid-20130228_231312_616835_703E3CC8)
Subject: Re: [PATCH] nl80211: re-add channel width and extended capa
 advertising
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: phaber@broadcom.com
Date: Thu, 28 Feb 2013 23:13:04 +0100
In-Reply-To: <1361976488-9773-1-git-send-email-johannes@sipsolutions.net> (sfid-20130227_154817_660820_11BC8BC2)
References: <1361976488-9773-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130227_154817_660820_11BC8BC2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 15:48 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add back the channel width and extended capability data
> to wiphy information if split information is supported.

Applied.

johannes


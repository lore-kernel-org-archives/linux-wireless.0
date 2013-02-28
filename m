Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130Ab3B1WMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:12:33 -0500
Message-ID: <1362089546.8330.4.camel@jlt4.sipsolutions.net> (sfid-20130228_231252_893414_91DDAA9E)
Subject: Re: [PATCH 3.9] nl80211: remove channel width and extended capa
 advertising
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: phaber@broadcom.com
Date: Thu, 28 Feb 2013 23:12:26 +0100
In-Reply-To: <1361975496-5862-1-git-send-email-johannes@sipsolutions.net> (sfid-20130227_153146_957263_5EE9E83F)
References: <1361975496-5862-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130227_153146_957263_5EE9E83F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 15:31 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is another case of data increasing the size of the
> wiphy information significantly with a new feature, for
> now remove this as well.

Applied.

johannes


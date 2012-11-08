Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751114Ab2KHJsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 04:48:03 -0500
Message-ID: <1352368108.9870.4.camel@jlt4.sipsolutions.net> (sfid-20121108_104816_905128_245E3D9C)
Subject: Re: [PATCH] mac80211: include export.h in aes_cmac
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 08 Nov 2012 10:48:28 +0100
In-Reply-To: <1352283757-20384-1-git-send-email-johannes@sipsolutions.net> (sfid-20121107_112219_331594_B0D9B679)
References: <1352283757-20384-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121107_112219_331594_B0D9B679)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 11:22 +0100, Johannes Berg wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This is needed since this file exports functions.

Applied.

johannes


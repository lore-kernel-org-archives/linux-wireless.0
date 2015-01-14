Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58147 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbbANI4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:56:53 -0500
Message-ID: <1421225811.1950.29.camel@sipsolutions.net> (sfid-20150114_095656_893572_2A0854E7)
Subject: Re: [PATCH iw] Read number of supported net-detect matches
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Jan 2015 09:56:51 +0100
In-Reply-To: <1421158755-23411-1-git-send-email-luca@coelho.fi>
References: <1421158755-23411-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-13 at 16:19 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Instead of just printing whether netdetect is supported, parse the
> attribute and report the maximum number of matchsets the driver
> supports.

Applied, thanks.

johannes


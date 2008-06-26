Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3385 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYFZURB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 16:17:01 -0400
Date: Thu, 26 Jun 2008 15:55:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: remove ieee80211_get_hdr_info
Message-ID: <20080626195513.GB28598@tuxdriver.com> (sfid-20080626_221707_404910_D4AA6685)
References: <1214200251.21092.23.camel@brick> <1214256225.21092.26.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214256225.21092.26.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2008 at 02:23:45PM -0700, Harvey Harrison wrote:
> >From 43070f098527c6f9022a83eb41e95b166e6d8605 Mon Sep 17 00:00:00 2001
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Mon, 23 Jun 2008 14:21:13 -0700
> Subject: [PATCH] mac80211: fix incorrect bit masking from previous patch
> 
> Checked ieee802.11-2007 and saw I changed this to mask one too many bits,
> the original comment is correct.

Would you mind posting a combined patch?

John
-- 
John W. Linville
linville@tuxdriver.com

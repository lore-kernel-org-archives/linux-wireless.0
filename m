Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54583 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbbCCInR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 03:43:17 -0500
Message-ID: <1425372195.2450.7.camel@sipsolutions.net> (sfid-20150303_094320_897005_7F132A5C)
Subject: Re: [PATCH] iw: display allowable channel bandwidth information
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@qti.qualcomm.com,
	vthiagar@qti.qualcomm.com
Date: Tue, 03 Mar 2015 09:43:15 +0100
In-Reply-To: <1423467418-3912-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1423467418-3912-1-git-send-email-arnagara@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-09 at 13:06 +0530, Ashok Raj Nagarajan wrote:
> We already have allowable channel bandwidth information at userspace.
> Display this information with 'iw list'. Excerpt of iw list command
> 
> Frequencies:
> 	* 5180 MHz [36] (17.0 dBm) (HT40+, VHT80, VHT160)

I think I would prefer this to be printed on a separate line, like the
radar information. There's also no-20 and no-10, which perhaps you
should handle?

johannes


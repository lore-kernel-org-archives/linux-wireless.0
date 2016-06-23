Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:36117 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751547AbcFWTZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 15:25:05 -0400
Message-ID: <1466709897.1847.24.camel@perches.com> (sfid-20160623_212534_710416_9DE85336)
Subject: Re: [PATCH] staging: wilc1000: arrays can't be NULL
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luisbg@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Date: Thu, 23 Jun 2016 12:24:57 -0700
In-Reply-To: <1466704629-26084-1-git-send-email-luisbg@osg.samsung.com>
References: <1466704629-26084-1-git-send-email-luisbg@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-23 at 18:57 +0100, Luis de Bethencourt wrote:
> hif_drv->usr_scan_req.net.net_info[i] contains found_net_info structs
> which have the following element:
> u8 bssid[6];
[]
> I am aware this patch gives a few checkpatch.pl warnings about lines being
> over 80 characters. Fixing that would be a completely different issue, and
> a lengthy one since the file has loads of them.
> 
> Hopefully somebody else picks that up. Maybe I should send a hit to the
> kernelnewbies mailing list :)

Or not.

really_long_identifiers™ makes using 80 columns silly.

The hungarian could probably be converted though.

A log of the memcpy and memcpy uses could probably be
converted to ether_addr_<foo> too.


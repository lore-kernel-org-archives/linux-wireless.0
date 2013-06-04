Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42945 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3FDKBk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:01:40 -0400
Message-ID: <51ADBB01.90804@openwrt.org> (sfid-20130604_120142_983334_EA9D809A)
Date: Tue, 04 Jun 2013 12:01:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: Re: [PATCH v2 2/2] ath9k: implement support for .release_buffered_frames()
References: <1370293129-24331-1-git-send-email-nbd@openwrt.org> <1370293129-24331-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1370293129-24331-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-03 10:58 PM, Felix Fietkau wrote:
> This adds support for PS-Poll and U-APSD driver-buffered frames (part of
> an aggregation session).
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Don't merge this just yet, found some issues that I need to fix first.

- Felix


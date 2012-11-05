Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab2KEOgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 09:36:44 -0500
Message-ID: <1352126240.9466.15.camel@jlt4.sipsolutions.net> (sfid-20121105_153656_734357_A7ED5760)
Subject: Re: [PATCH] wireless: add peer-to-peer related definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Mon, 05 Nov 2012 15:37:20 +0100
In-Reply-To: <1352125749-4500-1-git-send-email-arend@broadcom.com>
References: <1352125749-4500-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-05 at 15:29 +0100, Arend van Spriel wrote:
> The Peer-to-Peer IE is vendor-specific IE identified by WiFi Alliance
> OUI and specific P2P OUI type. The payload of this IE consists of
> so-called P2P attributes. This patch adds definitions for processing
> these attributes.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Johannes,
> 
> I reworked the patch adding only the enumeration.

Thanks, applied.

johannes


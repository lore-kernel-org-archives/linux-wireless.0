Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266Ab2JKQkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 12:40:42 -0400
Message-ID: <1349973674.13097.11.camel@jlt4.sipsolutions.net> (sfid-20121011_184045_877483_B2C7499B)
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Oct 2012 18:41:14 +0200
In-Reply-To: <1349965104-14475-1-git-send-email-arend@broadcom.com>
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-11 at 16:18 +0200, Arend van Spriel wrote:
> The Peer-to-Peer IE is vendor-specific IE identified by WiFi Alliance
> OUI and specific P2P OUI type. The payload of this IE consists of
> so-called P2P attributes. This patch adds definitions for processing
> these attributes.

Looks ok ... but why would a driver need to parse P2P stuff? For NoA for
example maybe?

johannes


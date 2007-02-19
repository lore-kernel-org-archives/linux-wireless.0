Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34130 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932609AbXBSUWq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:22:46 -0500
Date: Mon, 19 Feb 2007 21:22:44 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Fix wireless statistics reporting
Message-ID: <20070219212244.749c1088@griffin.suse.cz>
In-Reply-To: <200702112209.46093.flamingice@sourmilk.net>
References: <200702112209.46093.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 11 Feb 2007 22:09:41 -0500, Michael Wu wrote:
> This fixes statistics reporting. It allows drivers to specify what type of
> values they support, makes scan results return correct statistics, and
> generally fixes the brain damaged statistics reporting code.

Applied, thanks for the patch!

 Jiri

-- 
Jiri Benc
SUSE Labs

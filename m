Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0FOKF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 06:05:59 -0400
Subject: Re: [PATCH v2] iw: Configure basic rates when joining ibss network
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1276595169-3669-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276595169-3669-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 12:05:57 +0200
Message-ID: <1276596357.3648.91.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 12:46 +0300, Teemu Paasikivi wrote:

> +	/* basic rates */
> +	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {

>  	if (argc) {

> +COMMAND(ibss, join,
> +	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
> +	"[basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",

that doesn't match?

johannes


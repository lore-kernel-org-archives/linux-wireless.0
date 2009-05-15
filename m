Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:60422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbZEOSkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 14:40:15 -0400
Message-ID: <4A0DB70F.5000209@gmail.com>
Date: Fri, 15 May 2009 20:40:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com> <20090515182131.GA6439@fancy-poultry.org>
In-Reply-To: <20090515182131.GA6439@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2009 08:21 PM, Heinz Diehl wrote:
> This patchset crashes my WLAN. Reverting it does fix this:

Could you try this fix
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff_plain;h=b3f25c62aa41e0c372536c0f3975b39f21217b57;hp=30e2341dd2c82780eddd785eb54695115c6aea8d
?

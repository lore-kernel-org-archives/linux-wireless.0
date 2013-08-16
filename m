Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3HPKTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 06:19:55 -0400
Message-ID: <1376648388.15299.1.camel@jlt4.sipsolutions.net> (sfid-20130816_121959_346508_D5C43DD8)
Subject: Re: [PATCHv2 2/2] mac80211: non-functional change of rx handler
 location
From: Johannes Berg <johannes@sipsolutions.net>
To: Johan Almbladh <ja@anyfi.net>
Cc: ordex@autistici.org, linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 12:19:48 +0200
In-Reply-To: <1376486987-23224-2-git-send-email-ja@anyfi.net> (sfid-20130814_153105_600659_D0025A65)
References: <1376323275.11514.26.camel@jlt4.sipsolutions.net>
	 <1376486987-23224-1-git-send-email-ja@anyfi.net>
	 <1376486987-23224-2-git-send-email-ja@anyfi.net>
	 (sfid-20130814_153105_600659_D0025A65)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-14 at 15:29 +0200, Johan Almbladh wrote:
> This patch changes the location of the rx handler functions to match
> the new order in which they are invoked.

Applied both, but I squashed them into one.

johannes


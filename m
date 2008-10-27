Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYJ0Keg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 06:34:36 -0400
Message-ID: <1397eb932d5573ecf093fcbc82c02adb.squirrel@secure.sipsolutions.net>
In-Reply-To: <1ba2fa240810270330u15e3ce04y9d077904f48e04e7@mail.gmail.com> 
References: <1224923050.27353.1.camel@johannes.berg>
    <1ba2fa240810270330u15e3ce04y9d077904f48e04e7@mail.gmail.com>
Date: Mon, 27 Oct 2008 11:34:34 +0100 (CET)
Subject: Re: build warnings
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"Chr" <chunkeey@web.de>, "mcgrof" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Sat, Oct 25, 2008 at 10:24 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> just FYI in case you haven't seen them. the p54 one looks like a genuine
>> problem.
>>
>> drivers/net/wireless/iwlwifi/iwl-scan.c:69: warning: 'scan_tx_ant'
>> defined but not used
>
> Strange. This variable was removed in 'iwlwifi: unify tx antenna toggling'
> patch

odd. maybe I don't have the right tree here. Just mentioning the warnings
because in my experienced different gcc versions differ.

johannes


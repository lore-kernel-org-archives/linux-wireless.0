Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56391 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYK0LGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 06:06:54 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "Stefan Steuerwald" <salsasepp@googlemail.com>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Date: Thu, 27 Nov 2008 12:06:30 +0100
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200811242124.16358.chunkeey@web.de> <200811262213.03751.chunkeey@web.de> <f76a32050811270057r69df8f38p9cb4129bd98ce575@mail.gmail.com>
In-Reply-To: <f76a32050811270057r69df8f38p9cb4129bd98ce575@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811271206.30851.chunkeey@web.de> (sfid-20081127_120658_696017_D2A56786)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 November 2008 09:57:11 Stefan Steuerwald wrote:
> At least I haven't observed the crash in the last 60 minutes, whereas
> before it took only 1-2 minutes every time to turn it up.
> Will test this all day.

Finally!
 
> The three patches mentioned before are applied, and my app-level
> timeout is still gone, and the "dropped filtered TX" messages are gone
> as well.
> 
> Christian, should I actually test your p54-sta-flags-v3 patch?
> 
Yes, of course... v1 and v2 had a stupid "full queue" bug in p54_tx/p54_tx_fill.
So let me know if your ipod still works with v3.

Regards,
	Chr

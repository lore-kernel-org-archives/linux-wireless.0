Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:52369 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1EIRLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 13:11:49 -0400
Date: Mon, 9 May 2011 18:11:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Colin Guthrie <gmane@colin.guthr.ie>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [Regression] Problem with rfkill on 2.6.38
Message-ID: <20110509171144.GA7194@srcf.ucam.org> (sfid-20110509_191151_954695_17210551)
References: <ip6j66$o5f$1@dough.gmane.org>
 <1304930195.3475.17.camel@jlt3.sipsolutions.net>
 <4DC81FC7.9040503@colin.guthr.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DC81FC7.9040503@colin.guthr.ie>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 09, 2011 at 06:09:27PM +0100, Colin Guthrie wrote:

> Just a quick (non-compile) followup from my last email... blacklisting
> the dell-laptop module works around the issue, so I think the commit
> previously mentioned is indeed the culprit (as it's the only recent
> commit and does fiddle with the rfkill stuff).
> 
> Not sure what the best track forward is, but it's certainly a
> regression, so should probably be fixed or reverted until a more
> complete fix is found.

If you can confirm that with a build then I'll do that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

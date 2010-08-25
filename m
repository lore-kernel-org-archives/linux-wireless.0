Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0HYSoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 14:44:03 -0400
Subject: Re: Marshaling issues w/ compat-wireless-2010-08-19
From: Johannes Berg <johannes@sipsolutions.net>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <4C7563FE.10301@redfish-solutions.com>
References: <4C746F74.70401@redfish-solutions.com>
	 <1282723861.3685.4.camel@jlt3.sipsolutions.net>
	 <1282724412.3685.5.camel@jlt3.sipsolutions.net>
	 <4C7551A4.4040605@redfish-solutions.com>
	 <4C7563FE.10301@redfish-solutions.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 20:44:00 +0200
Message-ID: <1282761840.3667.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-25 at 11:42 -0700, Philip Prindeville wrote:

> Retried with yesterday's baking.  No joy.  Also reloaded the module
> with nohwcrypt=1 and same result (except that the value in the
> auth_alg field changed from 6421 to 44995).

Well, I'd expect it to change all the time since it's encrypted and
depends on the WEP IV :)

But you'll have to figure out why the frame isn't decrypted. I'm not
sure why, I haven't ever seen this issue.

johannes


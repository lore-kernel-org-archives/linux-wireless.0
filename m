Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab3BRWQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 17:16:19 -0500
Message-ID: <1361225773.8555.50.camel@jlt4.sipsolutions.net> (sfid-20130218_231622_328182_D9254EFF)
Subject: Re: Crash on removal of 400 interfaces (3.7.6+)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 18 Feb 2013 23:16:13 +0100
In-Reply-To: <5122A7C7.3070508@candelatech.com> (sfid-20130218_231436_933191_3F8FE600)
References: <5122A7C7.3070508@candelatech.com>
	 (sfid-20130218_231436_933191_3F8FE600)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 14:14 -0800, Ben Greear wrote:
> We often see crashes in work-queue processing when deleting
> lots of wifi station interfaces.  I'm guessing that there is probably
> a work item that was not properly un-registered before deleting
> memory.  I have backported some wifi fixes from upstream, so
> maybe they are to blame, but in case anyone has any suggestions
> for places to look, please let me know.

Enable CONFIG_DEBUG_OBJECTS and CONFIG_DEBUG_OBJECTS_WORK :)

johannes


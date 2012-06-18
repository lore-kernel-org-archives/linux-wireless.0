Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FRLps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 07:45:48 -0400
Message-ID: <1340019946.4615.3.camel@jlt3.sipsolutions.net> (sfid-20120618_134552_300335_4A263DD8)
Subject: Re: [RFC 0/5] bind filters and multicast list to subif
From: Johannes Berg <johannes@sipsolutions.net>
To: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 Jun 2012 13:45:46 +0200
In-Reply-To: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-18 at 12:57 +0200, Lukasz Kucharczyk wrote:
> Hi,
> 
> Following patches enables configuring filters and multicast list for
> specific interface. That probably might be useful in implementation
> of multi-channel operation.

"Might be useful"?

I guess I can see that, but we need
 a) driver updates
 b) to keep a global filter setting for drivers that don't have
    per-interface settings

johannes


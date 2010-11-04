Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0KDUyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:54:06 -0400
Subject: Re: [RFC 00/15] Implementation of periodic scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:51:07 -0400
Message-ID: <1288885867.3659.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:

>   This set doesn't support variable intervals, and the intervals
> need to be configure in the hw driver.

which is wrong -- you really want that to be configurable.

> This is an initial implementation and I'd like to get some comments before
> submitting the final version.
> 
> I've split the implementation in many small patches, just to keep it clear
> and due to the zillions of times I've had to task switch while implementing
> this.  I can merge some of them, if that makes things cleaner.

Absolutely, the patch splitting is total crap :-) Heck, you even write
code only to remove/change it again!

johannes


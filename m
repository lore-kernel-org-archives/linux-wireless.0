Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53727 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbJUMFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:05:41 -0400
Message-ID: <1445429136.4558.32.camel@sipsolutions.net> (sfid-20151021_140543_532046_314760BE)
Subject: Re: [PATCH] iw: Fix segfault when no args are given to offchannel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Wed, 21 Oct 2015 14:05:36 +0200
In-Reply-To: <1445428944-21589-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_140253_973742_92E2EA55)
References: <1445428944-21589-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151021_140253_973742_92E2EA55)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-21 at 14:02 +0200, Ola Olsson wrote:
> The offchannel command assumes that frequency and duration
> are given as arguments, otherwise iw segfaults - fix that
> by printing help text instead.
> 
Thanks! Applied, but I removed the unnecessary braces.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab0FOHcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 03:32:25 -0400
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi
 activity.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 09:32:20 +0200
Message-ID: <1276587140.3648.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 10:50 +0530, Vivek Natarajan wrote:

>  	case LED_FULL:

I wonder if you can just use different triggers which may be easier?
Look at what I suggested earlier for integrating the LEDs with iwlwifi:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/51218/focus=51520

Up to you, of course. I would love to do the iwlwifi stuff I suggested
but simply don't have time for it right now.

johannes


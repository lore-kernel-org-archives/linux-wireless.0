Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:58807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1EFQeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 12:34:12 -0400
Date: Fri, 6 May 2011 09:33:20 -0700
From: Greg KH <greg@kroah.com>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	Vipin.Mehta@Atheros.com, Naveen.Singh@Atheros.com
Subject: Re: [PATCH 1/2] ath6kl: Remove dead code with undefined
 EXPORT_HCI_BRIDGE_INTERFACE
Message-ID: <20110506163320.GA15144@kroah.com> (sfid-20110506_183416_122856_E720E06D)
References: <1304524691-12652-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1304524691-12652-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 04, 2011 at 09:28:10PM +0530, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

It's not as dead as you think it is, this series causes a build
breakage.

PLEASE TEST YOUR PATCHES!

To not do so, like you did here just makes me grumpy and not want to
deal with them at all...

greg k-h

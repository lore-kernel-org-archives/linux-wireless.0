Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583Ab0BRQM0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 11:12:26 -0500
Date: Thu, 18 Feb 2010 07:45:24 -0800
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Staging: r8187se: Remove two private variables
 that have a fixed value
Message-ID: <20100218154524.GA21785@kroah.com>
References: <4B78C7E8.5010403@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B78C7E8.5010403@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2010 at 10:04:56PM -0600, Larry Finger wrote:
> For the RTL8187SE, the variable priv->rf_chip is always RF_ZEBRA4
> and priv->RegThreeWireMode is always HW_THREE_WIRE_SI. Remove these
> 2 variables.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Careful with your email client, it wrapped the patch in places.  I fixed
it up, but in the future, can you please fix it on your end?

thanks,

greg k-h

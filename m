Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:56081 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab0BRRBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 12:01:42 -0500
Message-ID: <4B7D7270.6030900@lwfinger.net>
Date: Thu, 18 Feb 2010 11:01:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3 V2] staging: r8187se: Miscellaneous cleanups
References: <4b7963d0.cocDj1pGMQ3LKF4a%Larry.Finger@lwfinger.net> <20100218160340.GH21785@kroah.com>
In-Reply-To: <20100218160340.GH21785@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2010 10:03 AM, Greg KH wrote:
> On Mon, Feb 15, 2010 at 09:10:08AM -0600, Larry Finger wrote:
> 
> Ick, I just applied your first versions of these patches.  What was the
> difference here?  Care to look at the next linux-next tree and see if I
> missed anything?
> 
> sorry about that.

The only difference was that I fixed the line-wrap problem that you noted in
your previous Emails. I had found them and resubmitted. There were no content
changes in the patches and the tree appears to be OK.

Thanks for the heads-up and sorry for the trouble, Those damned long lines from
the Realtek driver are a pain.

FYI, the rewritten driver has received a beacon, and the first few parts have
been submitted to John Linville.

Larry

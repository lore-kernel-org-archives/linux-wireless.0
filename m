Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:46942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0IQAOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 20:14:43 -0400
Date: Thu, 16 Sep 2010 17:14:36 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <20100917001436.GA27148@kroah.com>
References: <1284682087-19351-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1284682087-19351-1-git-send-email-vmehta@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 05:08:07PM -0700, Vipin Mehta wrote:
> The commit fixes a compilation error that was encountered while using a specific kernel configuration file. The problem was the use of some fuunctions defined in <linux/semaphore.h> without including the header file explicitly. It was probably working before because of the dependency getting implicitly satisfied via some other header file. Also, eliminating the inclusion of the same header file more than once. The code needs additional cleanup and may be addressed by a subsequent commit.

Um, please wrap your lines at 72 columns.

> 
> Signed-off-by: Vipin Mehta <vmehta@atheros.com>

Did you forget to report who pointed out the problem to you?  That needs
to go in a:
	Reported-by: Foo <foo@baz.org>
line.

Care to redo this?

thanks,

greg k-h

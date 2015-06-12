Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbbFLOeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 10:34:12 -0400
Date: Fri, 12 Jun 2015 07:34:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: remove warnings reported by
 checkpatch.pl.
Message-ID: <20150612143411.GA23423@kroah.com> (sfid-20150612_163415_935336_93F74FB8)
References: <1434102716-3476-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434102716-3476-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 12, 2015 at 06:51:56PM +0900, Dean Lee wrote:
> Remove the following warnings in the wilc_log.h:
> - unnecessary whitespace before a quoted newline
> - line over 80 characters
> - single statement macros should not use a do {} while (0) loop.

Those are different things, so this should be broken up into different
patches.  Please make this a series of patches, each one only doing one
type of thing.

thanks,

greg k-h

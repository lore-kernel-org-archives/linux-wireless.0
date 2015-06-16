Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbbFPGD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 02:03:56 -0400
Date: Mon, 15 Jun 2015 23:03:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com
Subject: Re: [PATCH 1/3] staging: wilc1000: rework include wilc_oswrapper.h
Message-ID: <20150616060355.GA27044@kroah.com> (sfid-20150616_080400_196321_3BA41EF8)
References: <adf4906fecff029d52e8c8e0e1537dd7f9ef568c.1434432989.git.dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <adf4906fecff029d52e8c8e0e1537dd7f9ef568c.1434432989.git.dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 02:38:20PM +0900, Dean Lee wrote:
> rework line '#include "wilc_oswrapper.h"'
> it does not require after change own data type to common data type.
> 
> Signed-off-by: Dean Lee <dean.lee@atmel.com>

These are nice, but why isn't anyone sending me patches to fix the build
warnings in the driver right now?  That's preventing it from being
enabled in linux-next right now, please someone fix that...

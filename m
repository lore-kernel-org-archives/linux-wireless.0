Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f227.google.com ([209.85.217.227]:61736 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab0BQTSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 14:18:11 -0500
Date: Wed, 17 Feb 2010 11:18:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-input@vger.kernel.org, marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20100217191803.GB15554@core.coreip.homeip.net>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
 <20100217052247.GD7160@core.coreip.homeip.net>
 <20100217180342.GA22522@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100217180342.GA22522@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 06:03:42PM +0000, Matthew Garrett wrote:
> On Tue, Feb 16, 2010 at 09:22:47PM -0800, Dmitry Torokhov wrote:
> 
> > I'd like some breathing room aroung KEY_NUMERIC? Any issues with making
> > it 247 or 0x211?
> 
> None. Do you want to make that change, or should I resubmit?
> 

I'll change to 247 then.

Thanks.

-- 
Dmitry

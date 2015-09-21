Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbIUGGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 02:06:54 -0400
Date: Sun, 20 Sep 2015 23:06:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 1/2] staging: wilc1000: replace s32Error with result
Message-ID: <20150921060652.GA24030@kroah.com> (sfid-20150921_080656_812870_A4E13340)
References: <1442795132-19660-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442795132-19660-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 21, 2015 at 09:25:31AM +0900, Chaehyun Lim wrote:
> Most of functions use s32Error variable to check error and return its value.
> This patch replaces s32Error with result to avoid CamelCase.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>

This doesn't apply at all anymore.

I suggest doing as Julian said, fix this up correctly, no need to rename
a variable and then delete it in a later patch.  Start doing good
content cleanups, not just name replacements.

thanks,

greg k-h

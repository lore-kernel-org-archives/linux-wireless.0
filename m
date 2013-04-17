Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:33597 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab3DQA7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 20:59:41 -0400
Received: by mail-da0-f45.google.com with SMTP id v40so503974dad.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 17:59:41 -0700 (PDT)
Date: Tue, 16 Apr 2013 17:59:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/28] rtl8187se: Use a dir under /proc/net/r8180/ [RFC]
Message-ID: <20130417005934.GD11541@kroah.com> (sfid-20130417_025948_383354_0A75B393)
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182635.27773.93633.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130416182635.27773.93633.stgit@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 16, 2013 at 07:26:35PM +0100, David Howells wrote:
> Create a dir under /proc/net/r8180/ named for the device and create that
> device's files under there.  This means that there won't be a problem for
> multiple devices in the system (if such is possible) and it means we don't
> need to save the 'device directory' PDE any more as we can just do a proc
> subtree removal.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> cc: linux-wireless@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

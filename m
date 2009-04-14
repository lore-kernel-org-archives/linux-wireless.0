Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:39634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751838AbZDNCy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 22:54:56 -0400
Date: Mon, 13 Apr 2009 19:52:21 -0700
From: Greg KH <greg@kroah.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6655 driver to drivers/staging.
Message-ID: <20090414025221.GA18193@kroah.com> (sfid-20090414_045459_136361_831E0112)
References: <20090414024412.GA3771@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090414024412.GA3771@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 10:44:12PM -0400, Forest Bond wrote:
> This patch adds the vt6655 driver to drivers/staging.  This code was literally
> copied from the upstream source archive, available here:
> 
>   http://www.viaarena.com/Driver/vt6655_linux_src_v1.19.12_x86.zip
> 
> -Forest

I need a signed-off-by, as described in the file,
Documentation/SubmittingPatches, before I can apply it.

Also, who is the original author for this code?  We need some name for
it.

thanks,

greg k-h

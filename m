Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63835 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2J2L5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 07:57:16 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1921287bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 04:57:15 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Cliff McDiarmid <cliffhanger@gardener.com>
Subject: Re: RTL8188SU
Date: Mon, 29 Oct 2012 12:57:02 +0100
Cc: linux-wireless@vger.kernel.org
References: <loom.20121028T233054-8@post.gmane.org>
In-Reply-To: <loom.20121028T233054-8@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210291257.02249.chunkeey@googlemail.com> (sfid-20121029_125719_753568_4338389C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, October 28, 2012 11:34:04 PM Cliff McDiarmid wrote:
> As you know this chip uses the 8712u driver.  Is there any progress on this
> driver being able to handle monitor mode for use with aircrack?   At present I
> think I am using the latest staging version.
> 
Not with 8712u... This driver has no real support for monitor mode
just station and a bit of adhoc.

I put Josh' rtl8192su patches into a git repository
<https://github.com/chunkeey/rtl8192su> and started
adding things. This driver already does support monitor
mode and can connect to an legacy accesspoint. However 
as you can see the TODO list that comes with the driver
is quite long and a lot of important stuff is on it too.

Regards,
	Chr

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47115 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2KDMZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 07:25:10 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1912043eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 04:25:09 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Cliff McDiarmid <cliffhanger@gardener.com>
Subject: Re: 8192su beta - trying to build
Date: Sun, 4 Nov 2012 13:25:04 +0100
Cc: linux-wireless@vger.kernel.org
References: <loom.20121104T125621-892@post.gmane.org>
In-Reply-To: <loom.20121104T125621-892@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201211041325.04965.chunkeey@googlemail.com> (sfid-20121104_132618_266614_83DE911A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 November 2012 13:01:33 Cliff McDiarmid wrote:
> I'm trying to build this driver which I know is in beta.  I'm using a relatively
> new kernel (3.6.2).  Do I need an older one perhaps, getting the following error?

No, due to the developer process you need something even newer.
For a full description you can visit our wiki, but here's just
the relevant part:
<http://linuxwireless.org/en/developers/process#wireless-testing.git>
"Developers should work off of this git tree [wireless-testing.git]
for all 802.11 development."

Note: While rtl8192su should no longer cause a crash when
unloaded, the firmware rate control still needs to be
figured out (apparently something is very different from
rtl8192se).

Regards,
	Chr

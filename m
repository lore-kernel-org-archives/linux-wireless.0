Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60795 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1AHNDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 08:03:41 -0500
Received: by bwz15 with SMTP id 15so18015226bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jan 2011 05:03:40 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andre Kuehne <andre.kuehne@gmx.net>
Subject: Re: hwcrypt issue with rt73usb
Date: Sat, 8 Jan 2011 14:02:27 +0100
Cc: linux-wireless@vger.kernel.org
References: <4D2850B8.7080107@gmx.net>
In-Reply-To: <4D2850B8.7080107@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101081402.27745.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 8. Januar 2011 schrieb Andre Kuehne:
> On #linux-wireless it was suggested to test with nohwcrypt and indeed after
> 
>      modprobe rt73usb nohwcrypt=1
> 
> the connection worked fine again under kernel26-2.6.36.

Known issue. Please have a look at [1].

Helmut

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2JAGjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 02:39:04 -0400
Message-ID: <50693A84.8010102@gmail.com> (sfid-20121001_083925_878952_4031F662)
Date: Sun, 30 Sep 2012 23:39:00 -0700
From: Stephen Boyd <bebarino@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linux-kernel@vger.kernel.org
Subject: Re: rt73usb WARNING: at net/mac80211/driver-ops.h:12 check_sdata_in_driver
References: <505AD51F.7050709@gmail.com> <20120928124632.GG5368@mwanda>
In-Reply-To: <20120928124632.GG5368@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2012 05:46 AM, Dan Carpenter wrote:
> Hi Stephen,
> 
> I have created a bug for this:
> https://bugzilla.kernel.org/show_bug.cgi?id=48041
> 
> We only recently added the warning on that path.
> 
> Please add the following information.
> *) Complete dmesg
> 

Ok I've added the information to the bug. I'm still seeing it on 3.6.


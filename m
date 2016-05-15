Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34397 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbcEORri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2016 13:47:38 -0400
Received: by mail-io0-f173.google.com with SMTP id 190so186774004iow.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2016 10:47:38 -0700 (PDT)
Date: Sun, 15 May 2016 13:47:05 -0400
From: Bob Copeland <me@bobcopeland.com>
To: andy <lgkbiti@163.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wifi driver crashes openwrt device
Message-ID: <20160515174705.GA11620@localhost> (sfid-20160515_194744_335692_6F63CAB6)
References: <loom.20160510T171307-937@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20160510T171307-937@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2016 at 03:17:25PM +0000, andy wrote:
> hello, every body.
>   I developed an openwrt device based on git clone 
> git://git.openwrt.org/15.05/openwrt.git.
>   I found that my device rebooted during wifi initializing sometimes, maybe 
> one in twenty. 
>   The wifi driver is compat-wireless-2016-01-10.tar.bz2.
>   Could somebody give some hint or help me to resolve this wired issue?
>   Thank you very much.

Hi Andy,

You will probably need to capture a stack trace from the device in order
for someone to be able to help, otherwise we can only guess.  A serial
console can help with that.

-- 
Bob Copeland %% http://bobcopeland.com/

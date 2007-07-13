Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57966 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755781AbXGMMLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 08:11:38 -0400
Date: Fri, 13 Jul 2007 14:11:48 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Sushi Sensei" <sinestado@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Master mode on rtl8187
Message-ID: <20070713141148.16100abf@griffin.suse.cz>
In-Reply-To: <a63ecaf0707121239h51479d54m5e45174640e8c114@mail.gmail.com>
References: <a63ecaf0707121239h51479d54m5e45174640e8c114@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jul 2007 16:39:45 -0300, Sushi Sensei wrote:
> I have compiled the kernel 2.6.22.1 with git2 patch. This patch add:
> 
> [...]
> 
> # iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlan0 ; Invalid argument.

The code in vanilla doesn't support AP mode. Use wireless-dev tree
instead.

 Jiri

-- 
Jiri Benc
SUSE Labs

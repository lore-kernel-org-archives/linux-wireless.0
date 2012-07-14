Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48186 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2GNUu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 16:50:59 -0400
Received: by wibhm11 with SMTP id hm11so1630782wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jul 2012 13:50:58 -0700 (PDT)
Message-ID: <5001DBAF.3060605@gmail.com> (sfid-20120714_225107_032154_ABB6277C)
Date: Sat, 14 Jul 2012 22:50:55 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: dwmw2@infradead.org, Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] linux-firmware: add carl9170 firmware
References: <1342291606-11596-1-git-send-email-xose.vazquez@gmail.com> <1342295887.25597.487.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1342295887.25597.487.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/14/2012 09:58 PM, Ben Hutchings wrote:

> We need to include full source, not a pointer to it.

What do you mean ?

An entry like that, in the WHENCE file ?

Source: XXXXX

The complete package is about 111 files, but only 42 are the fw :
http://github.com/chunkeey/carl9170fw

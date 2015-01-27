Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46154 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbA0CWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 21:22:20 -0500
Received: by mail-ob0-f181.google.com with SMTP id nt9so11198091obb.12
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 18:22:20 -0800 (PST)
Message-ID: <54C6F65A.90009@lwfinger.net> (sfid-20150127_032224_735918_C7068A45)
Date: Mon, 26 Jan 2015 20:22:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "burton.b.williams@gmail.com >> Burton Williams"
	<burton.b.williams@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: RTL8192ee
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Burton,

I inadvertently deleted your E-mail, thus I cannot reply to it.

I am sorry that you have not had access to a driver for your wireless card. The 
initial driver was accepted into Linux in May 2014 in staging. It was probably 
not available to you because your distro is one of those that does not enable 
staging drivers. Perhaps you should consider a different distro.

In addition to that driver, another version of the one in kernel 3.18 was made 
available in a GitHub repo that was created in August 2014. That one contains 
all the newest versions, and was the source of the changes introduced in kernel 
3.18.

I have worked very hard on getting these drivers into the kernel. Comments like 
yours make me wonder if it has been worth my effort.

Larry

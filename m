Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33883 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbcBEGW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 01:22:58 -0500
Received: by mail-oi0-f48.google.com with SMTP id w5so35458777oie.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 22:22:57 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 4 Feb 2016 22:22:57 -0800
Message-ID: <CAD_1dL31XZeZBgtiESJMGLK8Jn5hDxjoi4F4ViuRHABGowoadw@mail.gmail.com> (sfid-20160205_072301_348061_8663A60A)
Subject: Finer grained control than ap_isolate
From: brian demsky <bdemsky2@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there a mechanism that can be used to allow some clients/ports on a
given SSID and AP to communicate, but to block others from
communicating?

In other words, can I implement something like firewall rules between
clients on the same SSID/AP?

Thanks,
Brian

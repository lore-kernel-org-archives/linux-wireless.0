Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:61246 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab0BCT35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 14:29:57 -0500
Received: by pxi27 with SMTP id 27so1668574pxi.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2010 11:29:57 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 3 Feb 2010 11:29:37 -0800
Message-ID: <43e72e891002031129m32549718p93a189a4047fe3d9@mail.gmail.com>
Subject: Please test new ar9170.fw
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please give the new ar9170 firmware a shot. Unfortunately I don't have
a changelog with it attached yet. This is based on the internal
proprietary code, not the open stuff. If this proves more stable maybe
its time to kick it into the linux-firmware git tree.

http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/2010-02-03/

  Luis

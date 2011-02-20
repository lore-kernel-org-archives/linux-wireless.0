Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33164 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab1BTUus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 15:50:48 -0500
Received: by qyg14 with SMTP id 14so484710qyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 12:50:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 20 Feb 2011 21:50:47 +0100
Message-ID: <AANLkTi=GprJyF0xmAioJa3SZ6888o3G2yA6DO1Dgie3h@mail.gmail.com>
Subject: Half-baked Compat-wireless releases
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the logs of latest Compat-wireless releases show:

> cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
> cat: compat_base_tree: No such file or directory
> cat: compat_base_tree_version: No such file or directory
> cat: compat_version: No such file or directory
> cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

Do these files exist? Has the build-script to be modified?

Regards.
- Sedat -

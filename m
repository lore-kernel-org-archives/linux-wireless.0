Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48971 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751316AbZI2Iux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 04:50:53 -0400
From: Malte Gell <malte.gell@gmx.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: cannot compile compate-wirless snapshots
Date: Tue, 29 Sep 2009 10:50:54 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909260457.21103.malte.gell@gmx.de> <4ABDE7AC.1090409@hauke-m.de>
In-Reply-To: <4ABDE7AC.1090409@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909291050.54388.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hauke Mehrtens <hauke@hauke-m.de> wrote


> Does this file exists in your installation?
> /lib/modules/`uname -r`/build/include/linux/tracepoint.h ?

Yes, but, look:

cd /usr/src/linux

grep -i tracepoint .config

# CONFIG_TRACEPOINTS is not set

Do I need to set it to yes?

Malte

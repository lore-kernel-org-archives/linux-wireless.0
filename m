Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46293 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2AYMX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 07:23:56 -0500
Received: by pbaa10 with SMTP id a10so2981564pba.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2012 04:23:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1FDEAE.2020009@01019freenet.de>
References: <4F1EF618.6080108@01019freenet.de>
	<13411135.eH6opTgxBo@helmutmobil.site>
	<4F1FBA09.3000003@01019freenet.de>
	<4F1FDEAE.2020009@01019freenet.de>
Date: Wed, 25 Jan 2012 13:23:55 +0100
Message-ID: <CAGXE3d9Lrk+ginqqbxVM+v_+fpnhu=y_R=TGdyoy+ZWuLtfbtQ@mail.gmail.com> (sfid-20120125_132420_496785_5C9A6FFE)
Subject: Re: ath9k get's completely knocked out by rt3572 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 25, 2012 at 11:51 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> As promised, I repeated the test before with another AP. The destination
> host of netperf was the same. See below!

So, in total it looks a little bit better then with the rt2800pci AP
but still the
airtime is distributed not equally but the Ralink STA seems to get a higher
amount of airtime :(

Maybe the ralink driver treats the channel access parameters differently?

Helmut

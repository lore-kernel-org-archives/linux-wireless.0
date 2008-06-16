Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37428 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYFPI0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 04:26:33 -0400
From: Chr <chunkeey@web.de>
To: "Mark Roberts" <mroberts1839@gmail.com>
Subject: Re: Problem with master mode on BCM4318
Date: Mon, 16 Jun 2008 10:26:28 +0200
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com> <20080616023427.gm71g7actwc8scsg-cebfxv@webmail.spamcop.net> <eaf2efa20806160010u4bc87ea9tb42c663dcf8444c1@mail.gmail.com>
In-Reply-To: <eaf2efa20806160010u4bc87ea9tb42c663dcf8444c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161026.28445.chunkeey@web.de> (sfid-20080616_102637_176412_69BD59D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 16 June 2008 09:10:12 Mark Roberts wrote:
> What steps should I take to apply the patches?

well, I don't know much about compat-wireless, but 
for the current wireless-dev, you have to get atleast one patch form:

http://johannes.sipsolutions.com/patches/kernel/all/LATEST/

and there: 006-allow-ap-vlan-modes.patch

For the userspace: you have to compile the _cutting-edge_ hostapd (afaik
0.6.4 git), you'll need it even for a unencrypted network!

Regards,
	Christian


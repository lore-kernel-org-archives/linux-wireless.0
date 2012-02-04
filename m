Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59010 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2BDKYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 05:24:22 -0500
Received: by vcge1 with SMTP id e1so3114511vcg.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Feb 2012 02:24:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201202041408.35588.lindner_marek@yahoo.de>
References: <20120202042521.GA20635@ubuntu-macmini>
	<4F2A830A.8000905@openwrt.org>
	<20120202143843.GB24483@ubuntu-macmini>
	<201202041408.35588.lindner_marek@yahoo.de>
Date: Sat, 4 Feb 2012 02:24:21 -0800
Message-ID: <CAJ-VmombdZ4QLKFA84d=5zZgDZ8yQEUkudfqDQiaqOEb_m2opw@mail.gmail.com> (sfid-20120204_112455_037373_9B2423D1)
Subject: Re: CTS timeout issue with AR9285
From: Adrian Chadd <adrian@freebsd.org>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

Felix, can we please revert that patch until we figure out why that's occuring?

(And I now need to make sure I'm doing that in FreeBSD's HAL, as I'm
pretty sure I've seen this with FreeBSD in the past.)



Adrian

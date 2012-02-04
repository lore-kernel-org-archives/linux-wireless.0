Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58161 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2BDUTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 15:19:10 -0500
Message-ID: <4F2D92B3.9010103@openwrt.org> (sfid-20120204_211922_552701_17D5B299)
Date: Sat, 04 Feb 2012 21:18:59 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Marek Lindner <lindner_marek@yahoo.de>,
	Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: CTS timeout issue with AR9285
References: <20120202042521.GA20635@ubuntu-macmini> <4F2A830A.8000905@openwrt.org> <20120202143843.GB24483@ubuntu-macmini> <201202041408.35588.lindner_marek@yahoo.de> <CAJ-VmombdZ4QLKFA84d=5zZgDZ8yQEUkudfqDQiaqOEb_m2opw@mail.gmail.com>
In-Reply-To: <CAJ-VmombdZ4QLKFA84d=5zZgDZ8yQEUkudfqDQiaqOEb_m2opw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-04 11:24 AM, Adrian Chadd wrote:
> hi,
> 
> Felix, can we please revert that patch until we figure out why that's occuring?
> 
> (And I now need to make sure I'm doing that in FreeBSD's HAL, as I'm
> pretty sure I've seen this with FreeBSD in the past.)
I don't think we need to revert the original change. I'll send this fix
as a patch for 3.3 soon, that makes the CTS timeout value match what
Atheros uses, so it should be safe.

- Felix

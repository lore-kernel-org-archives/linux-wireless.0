Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56586 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0DSM3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 08:29:16 -0400
References: <1271602602-8538-1-git-send-email-nbd@openwrt.org> <1271602602-8538-2-git-send-email-nbd@openwrt.org> <1271602602-8538-3-git-send-email-nbd@openwrt.org> <1271602602-8538-4-git-send-email-nbd@openwrt.org> <1271602602-8538-5-git-send-email-nbd@openwrt.org> <1271602602-8538-6-git-send-email-nbd@openwrt.org> <1271602602-8538-7-git-send-email-nbd@openwrt.org> <1271602602-8538-8-git-send-email-nbd@openwrt.org> <g2i133e8d7e1004190522n7dff80c3v1238a9f72cff734f@mail.gmail.com>
Message-Id: <9A06F358-B052-4288-934B-6554CE603497@nbd.name>
From: Felix Fietkau <nbd@nbd.name>
To: =?utf-8?Q?Bj=C3=B6rn_Smedman?= <bjorn.smedman@venatech.se>
In-Reply-To: <g2i133e8d7e1004190522n7dff80c3v1238a9f72cff734f@mail.gmail.com>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: [PATCH 8/9] ath9k: add support for Tx and Rx STBC
Date: Mon, 19 Apr 2010 14:28:41 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19.04.2010, at 14:22, Björn Smedman <bjorn.smedman@venatech.se>  
wrote:

> Hi all,
>
> Is STBC not supported on any chipsets other than  
> AR_SREV_9280_10_OR_LATER(ah)?
Right. AR9160 and older do not support this - at least according to  
sources and datasheets.

- Felix
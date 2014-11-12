Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44907 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:35:14 -0500
Received: by mail-oi0-f43.google.com with SMTP id e131so9385237oig.16
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:35:13 -0800 (PST)
Message-ID: <5463D28F.9080106@lwfinger.net> (sfid-20141112_223521_748694_A407390B)
Date: Wed, 12 Nov 2014 15:35:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Etna <etna@openmailbox.org>, linux-wireless@vger.kernel.org
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org> <20141027152026.GB19976@tuxdriver.com> <544E8CB4.3000607@rempel-privat.de> <20141028134608.GA26283@tuxdriver.com> <544FA303.5060303@broadcom.com> <544FA627.3000004@rempel-privat.de> <5450BEB2.60208@openwrt.org> <5461F937.9060004@rempel-privat.de> <5463CB6C.3030204@openwrt.org>
In-Reply-To: <5463CB6C.3030204@openwrt.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2014 03:04 PM, Felix Fietkau wrote:
> The chips I'm working with are both MT7662 and MT7612. My driver already
> works as a simple AP or station in 802.11n mode with some limited
> aggregation support. I'm getting around 45-50 Mbit/s TCP throughput on
> HT20 with iperf. I will post code soon, stay tuned!

Felix,

If your driver will work with the MT7630, I will be happy to test it when posted.

Larry



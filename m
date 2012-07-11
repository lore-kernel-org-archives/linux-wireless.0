Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40685 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2GKTAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120711183320.GB1937@tuxdriver.com>
References: <20120711181721.GC1906@tuxdriver.com>
	<20120711183320.GB1937@tuxdriver.com>
Date: Wed, 11 Jul 2012 21:00:50 +0200
Message-ID: <CACna6rwN+tBu=BG0TR2udq3PH9qvPg44jJQPGc4G3jH_t2=GjQ@mail.gmail.com> (sfid-20120711_210101_472954_2F255E7D)
Subject: Re: pull request: wireless-next 2012-07-11
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/11 John W. Linville <linville@tuxdriver.com>:
> Ugh, forgot the signature again...
>
> On Wed, Jul 11, 2012 at 02:17:22PM -0400, John W. Linville wrote:
>> Rafał Miłecki (2):
>>       b43: N-PHY: fix RSSI calibration
>>       bcma: use custom printing functions

MIPS users: bcma patch breaks compilation for you (sorry!), please apply
bcma: fix CC driver compilation on MIPS
locally before it gets merged.

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab1CPPCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 11:02:08 -0400
Date: Wed, 16 Mar 2011 16:01:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [rt2x00] New device id?AirLive WN-5000USB v2 (1b75:2770)
Message-ID: <20110316150151.GA2185@redhat.com>
References: <AANLkTik25XJ0DKhH3e=vr=wRL65hqoRQyjKdDRUXvt1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTik25XJ0DKhH3e=vr=wRL65hqoRQyjKdDRUXvt1c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 01:29:18PM +0100, Rafał Miłecki wrote:
> Is there a way to add card's ID on the fly, without recompiling kernel?

echo $ID > /sys/bus/$BUS/drivers/$DRIVER/new_id

Stanislaw

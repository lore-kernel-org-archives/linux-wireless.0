Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:36276 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbbAZIyy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:54:54 -0500
Message-ID: <54C5FEB0.1000609@neratec.com> (sfid-20150126_095518_076674_ED4F1928)
Date: Mon, 26 Jan 2015 09:45:36 +0100
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: "Christopher M. Penalver" <christopher.m.penalver@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Inquiry on sudo iw dev wlan1 set txpower fixed 14 -> command
 failed: Invalid argument (-22)
References: <CAF4BKcCggD23NHD_1156bqLsqMjDWp+8ASJaxJdLXUXcXaaddQ@mail.gmail.com>
In-Reply-To: <CAF4BKcCggD23NHD_1156bqLsqMjDWp+8ASJaxJdLXUXcXaaddQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/01/15 03:00, Christopher M. Penalver wrote:
> Attempting to follow
> http://wireless.kernel.org/en/users/Documentation/iw#Setting_TX_power
> I get:
> sudo iw dev wlan1 set txpower fixed 14
> command failed: Invalid argument (-22)
>
>

iw dev <devname> set txpower <auto|fixed|limit> [<tx power in mBm>]

This is set in mBm and not in dBm.
Try sudo iw dev wlan1 set txpower fixed 1400.

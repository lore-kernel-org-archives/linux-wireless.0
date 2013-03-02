Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:33283 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab3CBK1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 05:27:14 -0500
Message-ID: <5131D400.3070506@erley.org> (sfid-20130302_112717_769927_5BDB4D9E)
Date: Sat, 02 Mar 2013 05:27:12 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Abdelmuhaimen Seaudi <aseaudi@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Intel Wifilink 5100 AGN - Does it support Access Point Infrastructure
 Mode ?
References: <CABFmVg5sPub5Q4n+7PnkUn7weQLEUabONeJQZY6aFS2yFZAf2Q@mail.gmail.com> <CABFmVg5AaTG-F_myEA=WGdYpnwN9X=QfLcjKvwJ1-SUX0quaOg@mail.gmail.com> <CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com>
In-Reply-To: <CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/02/2013 04:51 AM, Abdelmuhaimen Seaudi wrote:
> Hello iwlwifi support,
> I want to run my Wifi Intel WifiLink 5100 AGN in Access Point
> Infrstructure Mode, so that I can connect via WiFi with other devices
> to my workstation.
> This is under Ubuntu Linux 12.10.
> I have tried setting the wlan0 to run in master mode, but it gives me
> error, as shown below.
> Is it possible to run this WiFi radio in AP Infrstrucutre mode ? How ?
> Thanks,
>

<SNIP>

> 	Supported interface modes:
> 		 * IBSS
> 		 * managed
> 		 * monitor
> 	software interface modes (can always be added):
> 		 * monitor

It also looks like this chipset doesn't support master mode.

Pat Erley

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:49284 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYFMWXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 18:23:53 -0400
Received: from poczta.interia.pl (mi03.poczta.interia.pl [10.217.12.3])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id 46CB2ADC1E
	for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 00:23:51 +0200 (CEST)
Received: from [192.168.1.7] (d90-129-241-239.cust.tele2.pl [90.129.241.239])
	by poczta.interia.pl (INTERIA.PL) with ESMTP id B094A3C402
	for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 00:23:50 +0200 (CEST)
Message-ID: <4852F389.1070506@interia.pl> (sfid-20080614_002356_634190_7DBF3A61)
Date: Sat, 14 Jun 2008 00:24:09 +0200
From: Maciek Kaliszewski <mkalkal@interia.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 and WPA
References: <4852658A.4040402@interia.pl>	 <20080613132317.GB5333@tuxdriver.com>	 <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com>	 <48527D72.4070509@interia.pl> <1213375014.29669.36.camel@dv>	 <4852D6EB.3020304@interia.pl> <1213391287.22425.31.camel@dv>
In-Reply-To: <1213391287.22425.31.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> I suggest that you debug wpa_supplicant, specifically
> wpa_driver_wext_get_scan_results() in src/drivers/driver_wext.c.  Try
> printing iwe->cmd and iwe->len before the switch.  And please move it to
> the hostap list.  If there is anything definitely wrong with the driver,
> then please let us know.
>
>   

You are right . It may be wpa_supplicant issue . (I'm moving to hostap 
list as soon as I get subscribed )
Kernel is amd64 and wpa_supplicant is i386 binary.

Regards
Maciek Kaliszewski



----------------------------------------------------------------------
Podbij Dziki Zachod!Gra strategiczna online
Sprawdz >>> http://link.interia.pl/f1dff


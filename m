Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from posta.ti-edu.ch ([195.176.176.171]:58677 "EHLO ti-edu.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab2FYLiy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 07:38:54 -0400
Received: from [195.176.191.17] (account michal@idsia.ch)
  by ti-edu.ch (CommuniGate Pro WEBUSER 5.4.5)
  with HTTP id 69364748 for linux-wireless@vger.kernel.org; Mon, 25 Jun 2012 12:38:50 +0200
From: "Michal Kudelski" <michal@idsia.ch>
Subject: carl9170 driver - reducing the output power
To: linux-wireless@vger.kernel.org
Date: Mon, 25 Jun 2012 12:38:50 +0200
Message-ID: <web-69364863@ti-edu.ch> (sfid-20120625_133857_823472_8FF00D48)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm engaged in a research project that requires us to 
reduce the range of an ad-hoc wifi network. However, when 
I change the txpower (either using iwconfig, or iw 
command), I can only see the difference when I display the 
current configuration (e.g., with iwconfig). I cannot see 
any difference in the actual tx power observed on a 
spectrum analyzer.

Thus, my question is: is the function of changing the 
txpower really supported? If it is, what steps should I 
take to make it work? I tried with ifconfig up/down when I 
change the txpower, but it does not change anything. Maybe 
I do something wrong? Do I use the correct versions of the 
firmware and the driver?

I've noticed a patch related to this issue, published on 
2012-01-27 by Christian Lamparter. It seems that it is 
included in my driver version, but maybe I'm wrong and I 
should apply some additional patch?

We use NetGear WNDA3100(v1) hardware [Atheros 
AR9001U-(2)NG] and carl9170 driver 
(driverversion=3.0.0-21-generic firmware=1.9.2).

Best regards,
Michal Kudelski

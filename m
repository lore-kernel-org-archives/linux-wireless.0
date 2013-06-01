Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25917 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3FAMdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:33:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <drwho@infidigm.net>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: Ath6kl:  how to set custom mac address?
References: <88f1398e0d87f1c79c5781f07bb7fb20.squirrel@www.infidigm.net>
Date: Sat, 1 Jun 2013 15:33:35 +0300
In-Reply-To: <88f1398e0d87f1c79c5781f07bb7fb20.squirrel@www.infidigm.net>
	(drwho@infidigm.net's message of "Fri, 26 Apr 2013 13:41:05 -0400")
Message-ID: <877gienh7k.fsf@kamboji.qca.qualcomm.com> (sfid-20130601_143358_035757_A905208D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<drwho@infidigm.net> writes:

> Is there a way to set the mac address on an ath6kl device?  For example
> when loading the module?
>
> insmod ath6kl_core.ko mac=55:66:77:88:AA:BB
>
> or with ifconfig / ip?

This is not supported at the moment, sorry.

-- 
Kalle Valo

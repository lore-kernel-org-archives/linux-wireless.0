Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from remail2.raritan.com ([62.132.199.138]:47463 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2BOQP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 11:15:28 -0500
Message-ID: <4F3BDA1B.2070104@raritan.com> (sfid-20120215_171531_919374_DE6F0EE5)
Date: Wed, 15 Feb 2012 17:15:23 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi/rtl8192cu: scheduling while atomic / sleeping function
 called from invalid context
References: <4F3A7F71.6000008@raritan.com> <4F3ACC50.2000201@lwfinger.net> <4F3BB5C4.9040803@raritan.com> <4F3BCEC9.9030009@lwfinger.net>
In-Reply-To: <4F3BCEC9.9030009@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15.02.2012 16:27, Larry Finger wrote:
> If possible, I would like one favor before you leave. These traces
> should be a part of a report at bugzilla.kernel.org. Is this a
> regression? I have assumed so.

https://bugzilla.kernel.org/show_bug.cgi?id=42775

I cannot tell if this is a regression - I just startet to test the 
driver with this kernel.

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Burkhard Wessler

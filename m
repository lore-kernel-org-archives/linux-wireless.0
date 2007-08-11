Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41063 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbXHKP0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 11:26:44 -0400
Message-ID: <46BDD528.7050306@lwfinger.net>
Date: Sat, 11 Aug 2007 10:26:32 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How to use software encryption with WEP and mac80211
References: <46BD2C17.4000702@lwfinger.net> <200708111142.15991.mb@bu3sch.de> <46BDD038.4040207@lwfinger.net> <200708111715.23891.mb@bu3sch.de>
In-Reply-To: <200708111715.23891.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 11 August 2007 17:05:28 Larry Finger wrote:
>> This doesn't seem to work. I had tried it before. I guess I put your code back in again.
> 
> bcm43xx-mac80211 hwenc code does not work with v3 firmware.
> There is no working hwenc code for v3 firmware.
> 
> The above code should work to enable swenc, unless there's a bug in mac80211.

Thanks. That saves a lot of work. Now I know where to look.

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43157 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0AYSwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:52:16 -0500
Received: by bwz27 with SMTP id 27so2942868bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:52:14 -0800 (PST)
Message-ID: <4B5DE859.6080409@lwfinger.net>
Date: Mon, 25 Jan 2010 12:52:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Don Darling <darling.don@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
References: <4B5CD1FF.4090209@twilightblue.net> <b6c5339f1001250939r6d136927q51bba86f7102d826@mail.gmail.com>
In-Reply-To: <b6c5339f1001250939r6d136927q51bba86f7102d826@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2010 11:39 AM, Bob Copeland wrote:
> On Sun, Jan 24, 2010 at 6:04 PM, Don Darling<darling.don@gmail.com>  wrote:
>> I'm assuming this issue is related to the ath5k driver itself -- the network
>> I'm using is only WEP128, and doesn't need wpa_supplicant.
>
> Huh, I didn't think any mac80211 driver supported WEP 128.  Are you sure you
> weren't using madwifi before?  Or maybe WEP 104?

For the record, WEP104 and WEP128 are the same thing. The smaller number makes 
it explicit that the 24-bit IV is transmitted in the open. The same thing 
applies to WEP40 and WEP64.

Larry


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53552 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab0KKTTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 14:19:12 -0500
Received: by wyb28 with SMTP id 28so1035452wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:19:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289497988.3695.3.camel@jlt3.sipsolutions.net>
References: <AANLkTinDJxnMHEbQjUwWjT2MnW5r7gcxoZW7bZetT7a9@mail.gmail.com> <1289497988.3695.3.camel@jlt3.sipsolutions.net>
From: Cassiano Tartari <cassianotartari@gmail.com>
Date: Thu, 11 Nov 2010 17:18:50 -0200
Message-ID: <AANLkTikL5VCadteiDCfDeA5VL8kdofM1rN1gBKmUbG9O@mail.gmail.com>
Subject: Re: Overload Probe Request to send data
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry johannes, but I didn't understand what you said.

I need to send data without confiability, just in one way client->AP
and without association, and this information is too short.


On Thu, Nov 11, 2010 at 3:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-11-11 at 13:35 -0200, Cassiano Tartari wrote:
>> Hi,
>>
>>     I'd like to know if somebody could help me giving a way to modify
>> the iwlwifi driver to overload the Probe Requests to send data? Which
>> file I need to modify, for what word I need search for...
>
> Just give the data to iw in a vendor specific IE and iwlwifi will send
> it out. Don't modify the kernel at all.
>
> johannes
>
>

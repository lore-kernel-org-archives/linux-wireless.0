Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.versatel.nl ([62.58.50.90]:53333 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967244AbXHMGfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:21 -0400
Message-ID: <46BFFB4F.4050801@hhs.nl>
Date: Mon, 13 Aug 2007 08:33:51 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <200708122318.42283.flamingice@sourmilk.net>
In-Reply-To: <200708122318.42283.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 12 August 2007 22:50, Hans de Goede wrote:
>> Patch causing loose off connection within seconds when fully loading the
>> link with a local file transfer:
>> http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=62ee473d67b7ae353
>> d210b186abaadc37a642237
>>
>> Only associating and nothing else:
>> http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=7d59453a9dbe50dc9
>> bab846c410e39f8d5b10c83 And then specifically the changes to prism54common.c
>>
> Links not working.
> 

Darn, is there a gitweb of the wireless-dev git anywhere else, I'm pretty sure 
I can find those patches pretty quick again.

Regards,

Hans


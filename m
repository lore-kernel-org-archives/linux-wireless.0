Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.cosetrain.com ([88.198.146.2]:55039 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZLVLzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 06:55:52 -0500
Message-ID: <4B30B3C3.7040602@cosetrain.com>
Date: Tue, 22 Dec 2009 12:55:47 +0100
From: Florian Sesser <flomaillist@cosetrain.com>
MIME-Version: 1.0
To: Rui Paulo <rpaulo@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: o11s: Modularize Path Selection Protocol etc.
References: <4B2F9930.8070401@cosetrain.com> <7057634E-E560-413E-9FB2-163F5311E054@gmail.com>
In-Reply-To: <7057634E-E560-413E-9FB2-163F5311E054@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rui!

Thanks for your prompt reply. I will dig into the new draft ASAP.

(It is propably rude to ask for an up to date draft on this list? I
would, of course, discreetly profit from having it handy shortly...)

Greetings!

Florian

Me:
>> [...]
>> In my last patch [2], I introduced some new 32 bit struct
>> members, because, if I am not mistaken, these IDs should include a
>> vendor specific OUI, which enables a user to combine a path
>> selection protocol of vendor A with a path selection metric of
>> vendor B.

Rui:
> This has changed quite a bit on the latest 802.11s draft standards.
> If you want to use your own routing protocol and to be 802.11s
> compliant, you need to set the path selection protocol ID to 255 and
> append a vendor specific information element to the management frame.
> [...]
> Rui Paulo

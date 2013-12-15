Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53846 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3LOJPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 04:15:38 -0500
Message-ID: <52AD7335.1090101@broadcom.com> (sfid-20131215_101605_083447_47D1D0F4)
Date: Sun, 15 Dec 2013 10:15:33 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wpa_supplicant and driver reload
References: <52A82A1D.80409@broadcom.com> <2323CBC6-B7B3-49FF-882F-66B9F0B9A879@w1.fi>
In-Reply-To: <2323CBC6-B7B3-49FF-882F-66B9F0B9A879@w1.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2013 06:46 AM, Jouni Malinen wrote:
>
> On 11 Dec 2013, at 1:02 am, Arend van Spriel <arend@broadcom.com> wrote:
>
>> A basic questionIn my testing I normally stop wpa_supplicant when reloading my driver and start it again, but I was wondering whether this is needed. Can wpa_supplicant deal with interface index change for the network interface?
>
> Yes, it can.
>
> (Did you not try it before asking? Or did it fail in some way?)

It failed. On my Ubuntu machine it works fine, but it seems 
NetworkManager does give explicit RemoveInterface and CreateInterface 
dbus primitives. When running wpa_supplicant without NetworkManager it 
fails and it seems to be using the previous if_index. I will give 
another stare the wpa_s log and send it out when I can not make sense of it.

Regards,
Arend



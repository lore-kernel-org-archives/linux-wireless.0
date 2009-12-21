Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc4-s36.blu0.hotmail.com ([65.55.111.175]:1978 "EHLO
	blu0-omc4-s36.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbZLUW3O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 17:29:14 -0500
Message-ID: <BLU113-W211E9D9EFD5458887F8CFFBE820@phx.gbl>
From: Mike Marchywka <marchywka@hotmail.com>
To: <larry.finger@lwfinger.net>
CC: <netrolller.3d@gmail.com>, <linux-wireless@vger.kernel.org>
Subject: RE: I need a card that works reasonably easily with Debain- reccs?
Date: Mon, 21 Dec 2009 17:29:12 -0500
In-Reply-To: <4B2F9534.8020908@lwfinger.net>
References: <BLU113-W7635FBD7855C5257B07E4BE820@phx.gbl>,<69e28c910912210614v31edf6cej9abeddb17ab130d@mail.gmail.com>
 <BLU113-W10113EE534A08128E43979BE820@phx.gbl>,<4B2F9534.8020908@lwfinger.net>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




This is the info for the card,
04:06.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless [11ab:1faa] (rev 03)
but now that you have me going I would like to find a driver for this too,

04:07.0 Communication controller [0780]: Conexant Systems, Inc. HSF 56k Data/Fax Modem [14f1:2f20]

I don't like using a wrapped driver either but IIRC I got the machine like this and usually
it works fine but it really slow with current cable modem even when windoze machines are doing
fine. I guess I could connect through the windoze machine but they are already swamped with
2 open browser windows. 

Once I learn to use ip and the routing tables I was going to make this the only machine
in this area to have an active wireless connection and route all the others through
it but will make a huge bottleneck at 20kBps when others are getting 250 routinely.



Thanks.

note new address
Mike Marchywka
1975 Village Round
Marietta GA 30064
415-264-8477 (w)<- use this
404-788-1216 (C)<- leave message
989-348-4796 (P)<- emergency only
marchywka@hotmail.com
Note: If I am asking for free stuff, I normally use for hobby/non-profit
information but may use in investment forums, public and private.
Please indicate any concerns if applicable.







----------------------------------------
> Date: Mon, 21 Dec 2009 09:33:08 -0600
> From: Larry.Finger@lwfinger.net
> To: marchywka@hotmail.com
> CC: netrolller.3d@gmail.com; linux-wireless@vger.kernel.org
> Subject: Re: I need a card that works reasonably easily with Debain- reccs?
>
> On 12/21/2009 08:51 AM, Mike Marchywka wrote:
>>
>>
>>
>> Thanks.
>> As near as I can tell from the driver files it should be a netgear WG311v3
>> 802.11g. May be a card mismatch but I'd have to pull machine apart to check.
>>
>> Are there known issues with ndiswrapper or I shouldn't even ask here? LOL.
>>
>> If there are known easy/difficult cards on a faq/list somewhere I thought that
>> would help as driver support seems to be a big issue.
>
> Before you rip the machine apart, use lsusb or 'lspci -nn' to get the
> USB or PCI IDs for the device.
>
> Most of us saw far too many Windows Blue Screens of Death to allow any
> Windows code unchecked access to the inner rings of Linux, which is
> exactly what ndiswrapper does.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft’s powerful SPAM protection.
http://clk.atdmt.com/GBL/go/177141664/direct/01/
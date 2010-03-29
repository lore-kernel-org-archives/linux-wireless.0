Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from goliath.siemens.de ([192.35.17.28]:16272 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0C2NGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 09:06:38 -0400
Message-ID: <4BB0A5B1.9090003@siemens.com>
Date: Mon, 29 Mar 2010 15:05:53 +0200
From: Marco Porsch <marco.porsch@siemens.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iw station del broken?
References: <4BB0A16A.7080400@siemens.com> <1269867487.4131.28.camel@jlt3.sipsolutions.net>
In-Reply-To: <1269867487.4131.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:
> On Mon, 2010-03-29 at 14:47 +0200, Marco Porsch wrote:
>   
>> Hi list,
>>
>> is it just me or is 'iw dev <devname> station del <MAC address>' broken?
>>     
>
> No ... we decided a while ago that station manipulation in mesh was too
> hard to support and removed it.
>
> What's the use case anyway?
>
> johannes
>   
The use case is that, if I have some mesh points in a single room or one 
a small floor, I can simply give them a topology by removing the links 
between the STA, I do not wish to be directly connected.
Removing the links means 'iw dev <devname> set mesh_param 
mesh_auto_open_plinks 0', which blocks building up new peering links, 
and then removing some links with 'station del'.

Hmpf.. I used this feature quiet often...

Regards,
Marco

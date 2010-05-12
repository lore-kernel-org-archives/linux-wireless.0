Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:50694 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab0ELQmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 12:42:35 -0400
Message-ID: <4BEADA79.5050000@create-net.org>
Date: Wed, 12 May 2010 18:42:33 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Packet injection with ath9k
References: <4BE43C18.2030806@create-net.org> <j2v69e28c911005070935wb720d757labf3a0484aedefb8@mail.gmail.com> 	<4BE46584.5060304@create-net.org> <r2y69e28c911005091324sbff07538i28babb432e6751db@mail.gmail.com>
In-Reply-To: <r2y69e28c911005091324sbff07538i28babb432e6751db@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2010 10:24 PM, Gábor Stefanik wrote:
>>     u_int16_t       it_len;
>>     u_int32_t       it_present;
>>      
> AFAIK these 2 fields need to be little-endian even on big-endian
> machines. If your system is big-endian, this can cause problems.
>    

Thanks, that was indeed the issue. I totally missed this info
in the radiotap website. Everything is working fine now.

R.

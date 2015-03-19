Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53435 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbCSVkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 17:40:22 -0400
Message-ID: <550B4241.4040101@broadcom.com> (sfid-20150319_224025_323028_C14CEE35)
Date: Thu, 19 Mar 2015 22:40:17 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=FCrgen_Bausa?= <Juergen.Bausa@online.de>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>	  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>	  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>	  <loom.20150317T214603-379@post.gmane.org>	 <1426634407.11120.50.camel@redhat.com>	 <loom.20150318T222315-999@post.gmane.org> <1426714179.26901.37.camel@redhat.com> <5509F0B5.7030601@broadcom.com> <loom.20150319T215852-35@post.gmane.org>
In-Reply-To: <loom.20150319T215852-35@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/15 22:00, Jürgen Bausa wrote:
> Arend van Spriel<arend@...>  writes:
>>
>> Do you have brcmfmac driver built with CONFIG_BRCMDBG. If so you can
>> enable debug output by:
>>
>> sudo sh -c 'echo 0xd416>  /sys/module/brcmfmac/parameters/debug'
>>
>
> No, it doesnt have dbg set. I will try to compile my own kernel and then come
> back.

CONFIG_BRCM_TRACING is another way to get debug output, but I guess that 
is not enabled either.

Regards,
Arend

> Juergen
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


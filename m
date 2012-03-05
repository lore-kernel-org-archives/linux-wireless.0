Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4886 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab2CEJkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 04:40:12 -0500
Message-ID: <4F5489EE.20203@broadcom.com> (sfid-20120305_104049_820373_6D21D8A9)
Date: Mon, 5 Mar 2012 10:39:58 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compat: makes all compat symbols
 EXPORT_SYMBOL_GPL()
References: <1330729706-11113-1-git-send-email-mcgrof@frijolero.org>
 <4F52141C.2050808@broadcom.com>
 <20120303161537.0b4ac739@pyramind.ukuu.org.uk>
In-Reply-To: <20120303161537.0b4ac739@pyramind.ukuu.org.uk>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/03/2012 05:15 PM, Alan Cox wrote:
>> Some of the modules in this patch are dual-licensed. I was under the
>> impression that EXPORT_SYMBOL_GPL was specifically for GPL-only code
>> although I could not find any specifics in the Documentation folder. Do
>> you (or someone else) have a reference on this topic?
>
> If your code is licensed GPL or greater rights then you shouldn't have a
> problem. The module loader recognizes
>
> 	"GPL"
> 	"GPL v2"
> 	"GPL and additional rights"
> 	"Dual BSD/GPL"
> 	"Dual MIT/GPL"
> 	"DUal MPL/GPL"
>
> as legitimate users of _GPL. Any work which is derivative of the kernel
> (which in practise I suspect means almost any module) will need a GPL
> compatible licence anyway.
>

Hi, Alan

I found the list above in module.h, but was not sure whether it was ok 
to use _GPL for dual license. Thanks for clarifying this.

Gr. AvS


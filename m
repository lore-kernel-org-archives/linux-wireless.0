Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2260 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1CSI7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 04:59:52 -0400
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
 <loom.20110318T135709-526@post.gmane.org>
 <AANLkTi=FNBJh+cAqMx1zWontvja8qAVQ6xSZCPyKP-kJ@mail.gmail.com>
Date: Sat, 19 Mar 2011 09:59:37 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vsk1xnx83ri7v4@arend-laptop>
In-Reply-To: <AANLkTi=FNBJh+cAqMx1zWontvja8qAVQ6xSZCPyKP-kJ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 Mar 2011 20:49:36 +0100, Rafał Miłecki <zajec5@gmail.com> wrote:

> 2011/3/18 Arend van Spriel <arend@broadcom.com>:
>> some general AMBA AXI functions
>
> Can you at tell us what AMBA AXI is? Is AXI some longer name of AI?
>

AMBA (Advanced Microcontroller Bus Architecture) protocol is an open  
standard, on-chip interconnect specification for the connection and  
management of functional blocks in a System-on-Chip (SoC). AXI is one of  
the protocol definitions with the AMBA protocol suite. AXI stands for  
Advanced eXtensible Interface. The term AI is not an ARM term but an  
abbreviation we used and it probably means Amba Interconnect.

references: www.arm.com / www.amba.com

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"


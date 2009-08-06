Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:33648 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833AbZHFSbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:31:05 -0400
Message-ID: <4A7B2163.4030805@redfish-solutions.com>
Date: Thu, 06 Aug 2009 11:30:59 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jon Loeliger <jdl@bigfootnetworks.com>,
	linux-wireless@vger.kernel.org
Subject: Re: CRDA and cross-compilation
References: <4A7A8F7E.6020503@redfish-solutions.com>	 <1249569993.6446.2.camel@jdl-desktop>  <1249576886.14919.16.camel@mj>	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com> <1249580707.14919.29.camel@mj>
In-Reply-To: <1249580707.14919.29.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Pavel Roskin wrote:
> On Thu, 2009-08-06 at 09:56 -0700, Luis R. Rodriguez wrote:
> 
>> ACK, is it possible to make it simpler?
> 
> OK, here's my take.
> 
> We only need a native compiler to verify regulatory.bin.  I believe it's
> orthogonal to building CRDA.
> 
> For someone doing a cross-compilation, it makes no sense to verify the
> installed regulatory.bin.  Thus, the verification should be optional.
> 
> But the compilation of regdbdump shouldn't be.  Firstly, it's installed
> by "make install".  Secondly, somebody may want to verify regulatory.bin
> on the target system.
> 
> Here's the patch:
> 
[snip]

Dumb question but, why not just build a target and host version each of regdumpdb?

-Philip

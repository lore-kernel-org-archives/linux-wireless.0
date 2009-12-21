Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:11851 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbZLUIYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 03:24:34 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
Date: Mon, 21 Dec 2009 09:24:16 +0100
Cc: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
References: <4B2ECC72.40703@redfish-solutions.com>
In-Reply-To: <4B2ECC72.40703@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912210924.16481.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> And what are the steps to figuring out the dependency that
> keeps forcing it on?  Something must be doing a "select SSB"
> but I'm not sure what.  

"make xconfig", and then turn on "Options -> Show Debug Info".

Then you see the reverse dep.


Another thing would be "find -name Kconfig |xargs grep 
SSB_POSSIBLE" and then carefully check those files.


-- 
http://www.holgerschurig.de

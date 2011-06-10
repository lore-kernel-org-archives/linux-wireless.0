Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:46149 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab1FJI7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 04:59:40 -0400
Received: from lnx503.hrz.tu-darmstadt.de (lnx503.hrz.tu-darmstadt.de [130.83.156.232])
	by lnx141.hrz.tu-darmstadt.de (8.14.4/8.13.8) with ESMTP id p5A8xDQf017557
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 10:59:13 +0200
	(envelope-from rodrigo.dcarmo@seemoo.tu-darmstadt.de)
Received: from mail.cased.de (mail.cased.de [130.83.33.42])
	by lnx503.hrz.tu-darmstadt.de (8.14.4/8.14.4/HRZ/PMX) with ESMTP id p5A8fnpO004490
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 10:41:49 +0200
	(envelope-from rodrigo.dcarmo@seemoo.tu-darmstadt.de)
Received: from cased134.cased.tu-darmstadt.de (s0235.dyn.hrz.tu-darmstadt.de [130.83.104.235])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.cased.de (Postfix) with ESMTPSA id BE9D616218B
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 10:41:48 +0200 (CEST)
Message-ID: <4DF1D867.4060108@seemoo.tu-darmstadt.de> (sfid-20110610_105944_639322_630A78CE)
Date: Fri, 10 Jun 2011 10:40:07 +0200
From: Rodrigo do Carmo <rodrigo.dcarmo@seemoo.tu-darmstadt.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Compiling meshd in FreeBSD 8.2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First of all, I'm sorry if this is the wrong place to put this kind of 
questions. I would like to ask you, if someone could give me a hand with 
this. I'm trying to compile the meshd in a FreeBSD 8.2, but I can't get 
rid of this error message when doing make: "meshd.c:83: error: 'struct 
<anonymous>' has no member named 'variable'"... I've applied the patch 
to the kernel, the path to the openssl libraries are OK, in fact I also 
used the 1.0.0-beta2 as stated in the example, compiled from scratch. I 
also get the same error in a FreeBSD 6.4. Does anyone went to something 
similar?

Thanks so much in advance,
Rodrigo.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:42665 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbXHAIkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 04:40:39 -0400
Message-ID: <46B04704.3000409@warmcat.com>
Date: Wed, 01 Aug 2007 09:40:36 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: libertas: blows chunks on failed firmware load
References: <46AF913F.9010006@warmcat.com> <1185935705.17940.40.camel@xo-13-A4-25.localdomain> <46B01F86.5050406@warmcat.com> <200708010900.00514.hs4233@mail.mn-solutions.de>
In-Reply-To: <200708010900.00514.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger -

>> One of the other cheapo cards I randomly got was a Libertas
>> 88W8335 PC Card, I assume I am SOL on that as well.
> 
> No, you aren't.
> 
> I published the driver into the libertas tree what handles PC 
> Cards. At least mine (a compact flash based 8388), the one from 
> Marcin and another guy. The driver is still extremely new, maybe 
> a little bit fragile, but having people test this beast would be 
> wonderful.

Sure I will try it tonight, where should I go to get it?  The only trees
with "libertas" in the name on git.kernel.org don't seem to be the ones.

My goal with this to to make a whitelist of cards and chipsets that are
known to inject and monitor (and so work with penumbra) perfectly.

-Andy

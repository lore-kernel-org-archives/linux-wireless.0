Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40917
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753167AbXFMIFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 04:05:53 -0400
Date: Wed, 13 Jun 2007 01:06:10 -0700 (PDT)
Message-Id: <20070613.010610.08321860.davem@davemloft.net>
To: hs4233@mail.mn-solutions.de
Cc: linux-wireless@vger.kernel.org
Subject: Re: libertas warnings in upstream
From: David Miller <davem@davemloft.net>
In-Reply-To: <200706130953.57827.hs4233@mail.mn-solutions.de>
References: <Pine.SOC.4.64.0706131022450.12888@math>
	<200706130953.57827.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Wed, 13 Jun 2007 09:53:57 +0200

> > Tried to test-compile libertas on a 64-bit platform.
> 
> I don't have a 64 bit machine and can't therefore say anything
> about those 64 issues. However, sparse doesn't moan about
> anything, not sure if sparse checks 64bit issues on a 32bit
> machine.

You don't need 64-bit hardware, don't use this as a reason,
it's invalid.

There are lots of cross-build setups available out there, precompiled
and everything.

sparse can do 64-bit checking if you build using it for a 64-bit
target.  So if you have a cross compile setup, sparse will also do the
right thing.

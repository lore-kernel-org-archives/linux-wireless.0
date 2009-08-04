Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:54300 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbZHDMnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 08:43:47 -0400
Date: Tue, 4 Aug 2009 13:43:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Multiple rfkill knobs for the same hardware interface
Message-ID: <20090804124346.GA16711@srcf.ucam.org>
References: <200908041630.00533.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200908041630.00533.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 04, 2009 at 04:29:56PM +0400, Andrey Borzenkov wrote:

> So dell-laptop actually lies claiming that both radios are enabled. Even 
> if this is a bug that can be fixed, having two knobs for exactly the 
> same piece of hardware is confusing at the very least.

I've sent a fix for this bug. However, the functionality isn't entirely 
redundant. Control over the platform interface allows overriding of BIOS 
settings.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
